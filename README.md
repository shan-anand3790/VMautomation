**Self-Service VM Deployment via GitHub Actions**

**Architecture Overview**
User Interface: Corporate Chatbot (Predefined selection).

Input Mechanism: The Chatbot collects user selection, generates vm_inputs.json, and commits it to the GitHub Repository.

Orchestrator: GitHub Actions (CI/CD Pipeline).

Infrastructure as Code: Terraform.

Cloud Provider: Microsoft Azure.

Output: The system automatically generates a vm_output_details.json file (containing IP, Storage Name, etc.) and pushes it back to the repository for record-keeping.

**User Workflow**

**Step 1: Requesting a Resource**
Initiate Chat: User opens the "VM Request" bot.

Provide Inputs: User answers standard prompts:

Select Environment (Dev/Prod)

Select OS (Windows/Linux)

Select Size (Standard_D2s_v3, etc.)

Submit: Upon confirmation, the Chatbot automatically formats these inputs into JSON and pushes the file to the main branch of the GitHub repository.

**Step 2: Automated Provisioning (System Action)**
Trigger: The commit made by the Chatbot triggers the GitHub Actions pipeline.

Execution: Terraform validates the input and provisions the resources in Azure.

**Step 3: Retrieval of Details**
Completion: The pipeline completes in approximately 3-5 minutes.

Output: A file named vm_output_details.json is updated in the GitHub repository with the new server details (IP Address, Resource Group).

Notification: (Optional) The user checks the repository for the output file, or the Chatbot reads this file and notifies the user.

**3. System Logic (Backend Automation)**
        This section describes the technical process triggered by the bot.

**JSON Generation:** 
        The Chatbot creates a payload:

        JSON

        {
          "vm_name": "requested-via-bot-01",
          "environment": "prod",
          "size": "Standard_B2s"
        }
**Git Operations**
        The Chatbot authenticates via API and commits this JSON to vm_inputs.json in the repo.

**Terraform Plan & Apply:** 
        GitHub Actions picks up the change and runs the Terraform scripts.

**Output Persistence**

        Terraform outputs key data (IP, Disk Name).

        Pipeline saves this to vm_output_details.json.

        Pipeline commits and pushes this file back to the repo using a distinct "Bot User" identity.

**System Logic (Backend Automation)**
This section describes the technical process triggered by the bot.

JSON Generation: The Chatbot creates a payload:

JSON

{
  "vm_name": "requested-via-bot-01",
  "environment": "prod",
  "size": "Standard_B2s"
}
Git Operations: The Chatbot authenticates via API and commits this JSON to vm_inputs.json in the repo.

Terraform Plan & Apply: GitHub Actions picks up the change and runs the Terraform scripts.

Output Persistence:

Terraform outputs key data (IP, Disk Name).

Pipeline saves this to vm_output_details.json.

Pipeline commits and pushes this file back to the repo using a distinct "Bot User" identity.

Output: A file named vm_output_details.json is updated in the GitHub repository with the new server details (IP Address, Resource Group).

Notification: (Optional) The user checks the repository for the output file, or the Chatbot reads this file and notifies the user.
