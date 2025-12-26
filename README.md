**Self-Service VM Deployment via GitHub Actions**

**Architecture Overview**
User Interface: Corporate Chatbot (Predefined selection).

Input Mechanism: The Chatbot collects user selection, generates vm_inputs.json, and commits it to the GitHub Repository.

Orchestrator: GitHub Actions (CI/CD Pipeline).

Infrastructure as Code: Terraform.

Cloud Provider: Microsoft Azure.

Output: The system automatically generates a vm_output_details.json file (containing IP, Storage Name, etc.) and pushes it back to the repository for record-keeping.
