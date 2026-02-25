---
description: Analyze a .drawio file using the drawio-diagram-analyst agent to extract architectural logic, workflows, and data relationships
allowed-tools: Task
---

# Analyze Draw.io Diagram

This command uses the `drawio-diagram-analyst` subagent to analyze a specified Draw.io file.

## Steps
2. Launch the `drawio-diagram-analyst` subagent via the `Task` tool, passing the file path: $ARGUMENTS.
3. Present the analysis result returned by the agent to the user
