# Port-Forwarding

https://stevessmarthomeguide.com/understanding-port-forwarding/

## What are ports?

On a TCP/IP network every device must have an IP address.

The **IP address identifies the device**.

However a device can run **multiple** applications/services.

The **TCP/UDP port** identifies the **application/service** running on the machine.

The use of ports allow computers/devices to run multiple services/applications.

**Summary:**

Hierarchy:

1. TCP/IP network has
2. Devices (identified by IP Addresses) which run
3. Applications/services (identified by ports)

**Example:**

Imagine sitting on your PC at home, and you have two browser windows open. One looking at the Google website and the other at the Yahoo website.

the connection to Google would be:

**IP1 (Your computer)** + port 2020 ——– Google **IP2** + port **80** (standard port)

the connection to Yahoo would be:

**IP1 (Your computer)** + port 2040 ——–Yahoo **IP3** + port **80** (standard port)

**Notes**: **IP1** is the IP address of your PC. Client port numbers are **dynamically assigned** (2020 and 2040 are different) and can be reused once the session is closed.

## NAT (Network Address Translation)

```
components/
├─ preprocess_data
├─ upload_cleaned_data (CAN BE REMOVED IF USING IMAGE REGISTRY)
├─ model_training
├─ upload_model (CAN BE REMOVED IF USING IMAGE REGISTRY)
├─ model_evaluation
├─ tt66upload_metrics (CAN BE REMOVED IF USING IMAGE REGISTRY)
├─ deploy_to_some_cloud_service (CAN BE REMOVED IF USING IMAGE REGISTRY)
```

