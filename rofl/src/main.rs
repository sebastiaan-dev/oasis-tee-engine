use reqwest::Client;
use serde::Serialize;
use tokio::time::{Duration, sleep};

#[derive(Serialize)]
struct LogMessage {
    message: String,
    // timestamp: String,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = Client::new();
    let url = "http://0a16-2001-1c00-5a82-e300-9084-31fc-638e-605.ngrok-free.app/logs";

    loop {
        // Build the log message with current timestamp
        let log = LogMessage {
            message: "Periodic log message from Oasis network".into(),
            // timestamp: chrono::Utc::now().to_rfc3339(),
        };

        // Send POST request
        match client.post(url).json(&log).send().await {
            Ok(resp) if resp.status().is_success() => {
                println!("Log sent: {}", log.message);
            }
            Ok(resp) => {
                eprintln!("Failed to send log: HTTP {}", resp.status());
            }
            Err(err) => {
                eprintln!("Request error: {}", err);
            }
        }

        // Wait 10 seconds
        sleep(Duration::from_secs(10)).await;
    }
}
