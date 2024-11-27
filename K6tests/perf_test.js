import { check, sleep } from "k6";
import http from "k6/http";

export let options = {
  stages: [
    { duration: "1m", target: 20 },
    { duration: "1m", target: 20 },
    { duration: "1m", target: 0 },
  ],
  thresholds: {
    "http_req_duration": ["p(95)<500"], // Allow 95% of requests to take less than 500ms
  },
  discardResponseBodies: true,
};

export default function () {
  let res = http.get("https://bloodpressurecicd.azurewebsites.net/");
  check(res, { "status is 200": (r) => r.status === 200 });
  sleep(3);
}