# Task Sequencer - Enpal Assignment

This solution implements a configurable custom task management system in Salesforce using custom metadata. It allows mapping of a selected **Process** picklist value on `Opportunity` to a sequential set of `Opportunity_Task__c` records.

---

## 🚀 Setup Instructions

1. **Deploy the Project**
   - Use SFDX or VS Code to deploy this DX project to a fresh Salesforce Developer Org.
   - Run the following commands:
     ```bash
     sfdx force:auth:web:login -a TaskSequencer
     sfdx force:source:deploy -p force-app
     ```

2. **Deploy Required Metadata**
   - Ensure the following components are deployed:
     - Apex Classes:
       - `TaskService`
       - `TaskTriggerHandler`
       - `OpportunityTriggerHandler`
     - Apex Triggers:
       - `OpportunityTrigger`
       - `OpportunityTaskTrigger`
     - Custom Objects:
       - `Opportunity_Task__c`
       - `Task_Process__mdt`
       - `Task_Definition__mdt`
     - Custom Fields:
       - `Opportunity.Process__c`
     - Custom Metadata Records:
       - `Task_Process__mdt.Onboarding_Process`
       - `Task_Definition__mdt.Onboarding_Step1`
       - `Task_Definition__mdt.Onboarding_Step2`

3. **Run Test Classes**
   - Run all test classes to validate functionality:
     - `Test_TaskService`
     - `Test_TaskTriggerHandler`
     - `Test_OpportunityTriggerHandler`
   - Use this command:
     ```bash
     sfdx force:apex:test:run --resultformat human
     ```

---

## 🧠 Design Approach

### Data Model
- `Opportunity`: Contains a `Process__c` picklist (e.g., Onboarding, Installation, Support).
- `Task_Process__mdt`: Maps Process picklist values to a track name.
- `Task_Definition__mdt`: Defines the sequence of tasks for each track.
- `Opportunity_Task__c`: Stores tasks related to an Opportunity.

### Logic Flow
1. When an Opportunity is created or Process is updated (with no existing tasks):
   - First task (Sequence 1) is created automatically.
2. When an `Opportunity_Task__c` is marked **Completed**:
   - The next task in sequence is automatically created.
3. Prevent changing `Process__c` after task creation unless tasks are deleted.

---

## 🔧 Configuration Guide

Admins can configure new processes and tasks using **Custom Metadata**:

1. **Add a new process**
   - Create a new `Task_Process__mdt` record.
     - Label: e.g., `Installation Process`
     - Process_Value__c: `Installation`
     - Track_Name__c: `Installation_Track`

2. **Add task definitions**
   - Create `Task_Definition__mdt` records with:
     - Track_Name__c = `Installation_Track`
     - Sequence__c = 1, 2, 3, ...
     - Task_Name__c = Step name

> ⚠️ Only **one task per sequence per track** is allowed (enforced by code and metadata).

---

## ✅ Assumptions

- Each process (Onboarding, Installation, etc.) is **independent**.
- Tasks are executed **sequentially**, and only **one task per sequence** exists.
- `Process__c` cannot be changed once tasks are created.
- Task completion triggers the next task automatically.

---

## ✨ Potential Improvements

- Add error logging using a custom object (`Task_Sequencer_Log__c`)
- Add UI components for admins to view process-task mappings
- Add validation rule on `Task_Definition__mdt` to prevent duplicate sequences per track
- Extend support for record types or different object types

---

## 👩‍💻 Sample Org Access (Demo)

> ⚠️ Please replace with your real credentials before submitting.

- **Username**: `publicuser2025@enpal.com`
- **Password**: `SalesforceEnpal2025!`
- URL: https://enpal4-dev-ed.develop.lightning.force.com/lightning/page/home

Sample configuration is already set up with:
- Process: `Onboarding`
- Tasks: `Step 1`, `Step 2`

You can test by:
1. Creating a new Opportunity with `Process__c = Onboarding`
2. Marking Task 1 as Completed → Task 2 will be created automatically

---

## 📁 Directory Structure

