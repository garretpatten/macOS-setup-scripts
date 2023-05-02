#!/bin/bash

# Add non-automated tasks to Taskwarrior
if [[ -d "/usr/local/cellar/task/" ]]; then
	# High Priority Tasks
	task add Log in to iCloud project:mac priority:H
	task add Export GitHub PAT with 1Password project:dev priority:H

	# Medium Priority Tasks
	task add Sign in to 1Password project:sec priority:M
	task add Sign in to Simplenote project:setup priority:M
	task add Sync Brave project:setup priority:M
	task add Sync Firefox project:setup priority:M

	# Low Priority Tasks
	task add Configure VS Code settings project:dev priority:Low
	task add Install Burp Suite project:setup priority:L
	task add Download files from Proton Drive project:setup priority:L
else
	echo "Taskwarrior is not installed. Please install Taskwarrior and re-run the addTasks script."
fi
