# Core.sh contains all core functions for Aligne.
# it only contains logic no inputs like read no outputs like echo,
# it is used by other scripts to perform tasks.
# it contains following functions:
#
# core.sh — pure core functions (no interactive I/O)
# Available functions (each takes parameters and returns exit codes):
# 
#   new_playbook      Creates a new playbook file and applies meta-header.
#   new_task          Adds a task to a playbook.
#   new_role          Initializes a new Ansible role.
#   edit_playbook     Edits metadata or structure of an existing playbook.
#   edit_task         Edits a specific task within a playbook.
#   edit_role         Modifies an existing role.
#   edit_main_yml     Opens or restructures the playbook’s main.yml.
#   sort_main_yml     Sorts tasks in main.yml alphabetically or by type.
#   list_playbooks    Lists all available playbooks.
#   list_tasks        Lists all tasks in a given playbook.
#   list_roles        Lists all initialized roles.
#   show_playbook     Displays the content of a playbook.
#   show_task         Shows details of a single task.
#   show_role         Shows details of a role.
#   delete_playbook   Deletes a playbook file.
#   delete_task       Removes a task from a playbook.
#   delete_role       Deletes an entire role directory.
#
# Usage:
#   source core.sh
#   fucntionName "webserver" "nginx" "Felix "Deploy webserver role"
#


# Check if the script is being sourced, not executed directly
# Uncomment the following lines if you want to enforce sourcing
# This is useful to prevent accidental execution of the script.

#if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
#  echo "Sorry Mate, core.sh is meant to be sourced, not executed. Its innocent as a Bride." >&2
#  echo "I'll sadly have to tell you, that we wont continue this session." >&2
#  echo "Feel free to Start Aligne with aa-aligne or aa-newpb!" >&2
#  return 1
#fi

# ===== Functions ===== #

# === Function: new_playbook === #
# Creates a new playbook file and applies meta-header.
# if given, a role will be created an added to the playbook instantly.

# Parameters:
#   $1 - Playbook name (required)
#   $2 - Role name (optional)
#   $3 - Author name (optional, defaults to DEFAULT_AUTHOR_NAME)
#   $4 - Description (required but only warning, not enforced)


# Reusalble Test Mode
# Log of existing Variables
#for each var in $CONFIG_PATH/ansiblealine.conf; do
#  echo "Variable: $var"
#done


# Intitalization of Variables
CONFIG_PATH=/etc/ansiblealine
FUNCTION_PATH=/usr/local/bin/ansiblealine

# Import of Variables/Configs and Meta tag Header for Playbooks
. $CONFIG_PATH/ansiblealine.conf
. $CONFIG_PATH/meta_header.txt

new_playbook() {
  local playbook_name="$1"
  local role_name="$2"
  local author_name="$3"
  local description="$4"

 # Meta-data defaults
  local DEFAULT_AUTHOR_NAME="Aligne User"
  local DEFAULT_DESCRIPTION="No description provided."

 # Safety checks 

  # Saftycheck 2 if playbook name is provided (POSIX compliant)
    if ["$playbook_name" ]; then
        echo "$ERR_CLR Error: Playbook name is required."
        return 1
    fi

        # Saftycheck 2 if playbook already exists
        if [ -f $PLAYBOOK_PATH/$playbook_name.yml ]; then
            echo "$ERR_CLR Error: Playbook '$playbook_name' already exists." "(Exit: $?)
            return 1
        fi
 # Creation of the Playbook and Role if provided

    # Create the playbook file with meta-header with cr
    touch $PLAYBOOK_PATH/$playbook_name.yml
    if ! cat "$CONFIG_PATH/meta_header.txt" > "$PLAYBOOK_PATH/$playbook_name.yml"; then
        echo "${ERR_CLR} Error: Could not write meta-header to $playbook_name.yml (Exit: $?)"
        return 1
    fi
    echo "Playbook '$playbook_name' created successfully."