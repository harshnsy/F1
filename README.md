# fi

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Expense Management System: Complete Functional Guide
This document outlines the core capabilities of the Expense Management System, categorized by the functional area and target user role.

1. System Access and Authentication
This section details how users securely enter the system and manage their credentials.

A. Sign In (Sign in to continue to your account)
Users can access the system through several secure pathways:

Standard Login: Users enter their Email and Password. The Remember me option can be toggled to save credentials for future sessions.

Single Sign-On (SSO): Quick authentication is supported via Continue with Google or Continue with Microsoft.

Credential Recovery: A Forgot password? link is provided to initiate the recovery process.

B. Account Creation (Create your account)
New users can register by providing their Email and setting a new, secure password in the Create a password and Confirm password fields. Alternatively, they can use Sign up with Google or Sign up with Microsoft for rapid account creation. All users must agree to the system's Terms and Privacy Policy to proceed with account creation.

2. System Overview and Metrics (Dashboard)
The Dashboard provides executive-level insight into the financial health of the expense process.

Total Expenses: The cumulative monetary value of all claims processed by the system (e.g., $12,430).

Status Breakdown: Claims are tracked by current state: Approved ($8,960), Pending ($2,370), and Rejected ($1,100).

Expense Table: A centralized log of transactions that includes Date, Category, Amount, Status, and User for administrative and managerial review.

3. Employee Expense Management (User/Employee View)
This module enables employees to submit new claims and monitor their personal submissions.

A. Expense Submission (Add Expense)
Employees use the form to document a new claim by specifying the Date, Category, and Amount.

Justification: A detailed Description explaining the expense's purpose is mandatory.

Receipts and Payment: Employees must Upload supporting Receipts and identify who paid via the Paid by field.

Submission: The expense is saved as a Draft until the employee clicks Submit, moving it to the approval queue.

B. Status Tracking
The Employee's View table shows the history of personal claims, displaying the current status:

Draft: Saved but unsubmitted claims.

Waiting Approval: Claims actively under review.

Approved: Claims that have passed the full workflow. Employees can review Expense Details to see which Approver acted on the claim and at what time.

4. Manager and Approver Review (Manager's View)
This interface is designed for managers to efficiently review and act on expense claims from their teams.

Approvals to Review: The priority list of pending claims requiring action, which can be easily Searched or Filtered by status or category.

Decision Actions: Managers take definitive action on a claim directly from the list using the Approve or Reject buttons.

Detailed Review: Before acting, managers typically review the Expense Details, including the uploaded Receipt, to ensure compliance with policy.

5. Administrator and System Configuration (Admin View)
The Administrator is responsible for user provisioning and setting up organizational governance rules.

A. Employee Management
This view allows administrators to create and maintain employee records, including their Job Title and Department, which are essential details for automated workflow routing.

B. Approval Rules Configuration
The Admin View - Approval Rules module defines the necessary steps for claim sign-off:

Approver Definition: Specifies the required individuals (John, Mitchell, Andreas) and can optionally include the employee's direct Manager as an approver.

Workflow Type: The Approvers Sequence toggle determines the flow:

Sequential (Checked): Approvals must occur in a specific order. Rejection at any step halts the process.

Parallel (Unchecked): All approvers are notified simultaneously.

Quorum Setting: For parallel workflows, the Minimum Approval Percentage dictates the required threshold of approvals for the claim to pass.

The project look like :- https://www.figma.com/design/TayTw1nx3xLXHUUIwnlFZF/Untitled?node-id=0-1&t=o5zu335Maah0i2VN-1

