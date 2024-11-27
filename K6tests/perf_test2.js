import { check, sleep } from "k6";
import http from "k6/http";
import { parseHTML } from "k6/html";

export let options = {
  stages: [
    { duration: "1m", target: 20 },
    { duration: "20s", target: 5 },
    { duration: "20s", target: 0 },
  ],
  thresholds: {
    "http_req_duration": ["p(95)<500"], // Allow 95% of requests to take less than 500ms
  },
};

// Discard response bodies globally
export const discardResponseBodies = true;

// Get a random integer between `min` and `max`
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1) + min);
}

// Main test function
export default function () {
    // Perform initial GET request to get the form and CSRF token
    let res = http.get("https://bloodpressurecicd.azurewebsites.net/", { responseType: "text" });
  
    // Check if GET request was successful
    check(res, { "status is 200": (r) => r.status === 200 });

    // Parse the HTML response to extract the CSRF token
    const doc = parseHTML(res.body);
    const csrfToken = doc.find('input[name="authenticity_token"]').val(); // Extract CSRF token

    // Verify CSRF token is present
    check(csrfToken, {
      "CSRF token exists": (token) => token !== undefined && token !== "",
    });

    // Generate random values for the form fields
    const systolic = getRandomInt(70, 190);
    const diastolic = getRandomInt(40, 100);
  
    // Log the values being submitted by the VU
    console.log(`VU ${__VU} submitting: Systolic=${systolic}, Diastolic=${diastolic}`);
  
    // Simulate form submission with POST request
    const formData = {
      systolic: systolic.toString(),   // Random value for systolic
      diastolic: diastolic.toString(), // Random value for diastolic 
      commit: "Calculate",            // Submit button
      authenticity_token: csrfToken,  // CSRF token
    };

    res = http.post("https://bloodpressurecicd.azurewebsites.net/", formData, {
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
    });

    // Check if form submission was successful (status 200)
    check(res, { "is status 200": (r) => r.status === 200 });

    // Check if the blood pressure category is returned in the response
    check(res, {
      "contains blood pressure category": (r) =>
        r.body.includes("<h2>Your Blood Pressure Result:</h2>") && r.body.includes("<strong>" + systolic + "/" + diastolic),
    });

    // Extract and log the blood pressure result 
    const resultDoc = parseHTML(res.body);
    const result = resultDoc.find('h2').text();  // Extract the result section header
    const category = resultDoc.find('strong').text();  // Extract the category
    console.log(`VU ${__VU} - Blood Pressure Result: ${result} - Category: ${category}`);

    // Add a 3-second pause to simulate a user "thinking" before the next request
    sleep(3);
}