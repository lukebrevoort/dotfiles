---
name: pull-work
description: Pull the latest features and bugs from Notion Project Database
---

# Overview

Notion is where you will find ALL upcoming features and bug fixes for the project you are working on. This skill allows you to pull the latest updates from the Notion Project Database so you can stay informed about what needs to be done and begin work immediately with as much context as possible.

## The Process

1. Pull the latest features and bugs from the Notion Project Database. Database ID is: 2e5f7879ec1d80ff938ff91a30054411

- Use Notion MCP to fetch the latest entries from the project database.
- Look at PLAN.md or project root directory name to know which project database to pull from.

2. Select the most relevant feature or bug that need to be addressed.

- Filter the entries based on priority, status, and relevance to your current work.
- Identify any dependencies or related tasks that may impact your work
- ONLY select features or bugs that have the status "Open", this implies that the task is ready to be worked on.
- NEVER choose a feature or bug that is marked as "In Progress" or "Under Review", as these are already being handled by someone else.
- NEVER chooser a feature or bug that is marked as "Completed", as these have already been resolved.

3. Branch from GIT main branch.

- Create a new branch in your local GIT repository based on the main branch.
- Name the branch according to the feature or bug you are addressing for easy identification.
- Create a Pull Request through Github CLI to document updates and progress on the project, including subagent results if applicable.

4. Prepare to start working on the selected features and bugs.

- Review the details of each selected entry to understand the requirements and acceptance criteria.
- Gather any necessary resources or information needed to complete the tasks.
- Only consider the task complete when all acceptance criteria are met and the feature or bug has been thoroughly tested.

5. Once complete, update the Notion Project Database to "Under Review"

- Mark the feature and beug entries as "Under Review" in the Notion Project Database to indicate that the work is ready for review.
- Add any relevant notes or documentation about the work done for future reference in the Notion entry. It is important to be specific and detailed in your updates to ensure clarity for reviewers and team members.
