# python-venv.sh
#
# This file contains functions and aliases that simplifies creation, activation, and deactivation
# of Python's virtual environments (venv).
#
# Author: Alexander Roaas


# venv - This function provides a simplified way of creating a virtual environment
#        in the current directory. It will activate the created venv after creation.
function venv {
	VENV_NAME=$1

	if [ -z $VENV_NAME ];
  then
		echo "Please provide a name for the venv";
		return 1
	fi

	if [ -d ./.venv ];
	then
		echo "A virtual environment already exists in this directory"
		return 1
  fi

	python3 -m venv --prompt $VENV_NAME .venv
  source ./.venv/bin/activate
}

# avenv - Short for activate virtual environment. Looks for the first
#         occurence of the directory .venv moving backwards in the
#         file system until the defined limit is reached (hard 
#         limit is set to 30 to prevent misuse).
function avenv {
	V_PATH=".venv"
	V_COUNT=0
	V_LIM=$1

	if [ -z V_LIM ];
	then
		V_LIM=5
	fi

	while [ ! -d "${V_PATH}" ] && [ $V_COUNT -lt $V_LIM ] && [ $V_COUNT -lt 30 ];
	do
		V_PATH="../${V_PATH}"
		((V_COUNT++))
	done

	if [ -d "${V_PATH}" ];
	then
		source ${V_PATH}/bin/activate
		return 0
	fi

	echo "No venv found (depth=$V_LIM)"
}

# dvenv - Short for deactivate virtual environment. Sources the default rc file.
#					Ensure this matches the shell you use (.bashrc, .zshrc, etc.).
alias dvenv="source ~/.bashrc"
