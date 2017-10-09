set -e +o pipefail

DEFAULT_DEPS="Django "
DEFAULT_DEPS+="git+https://github.com/5monkeys/django-bananas.git@1.0.12b1#egg=django-bananas "
DEFAULT_DEPS+="djangorestframework "
DEFAULT_DEPS+="raven "
DEFAULT_DEPS+="flake8 "

echo -en "Collecting resources\n"

wget -q -O django-project-template.tar.gz https://github.com/app-shack/django-project-template/releases/download/v1.0.0/django-project-template.tar.gz

temp=`mktemp -d 2>/dev/null || mktemp -d -t 'dpr'`
tar -xzf django-project-template.tar.gz -C "$temp" --exclude "*/init.sh" --exclude ".gitignore" && \
    mv -n "$temp"/*/* . && \
    rm -r "$temp"
rm -f django-project-template.tar.gz

read -p "Enter new project name: " project_name

echo -en "Install base requirements\n"
pip install $DEFAULT_DEPS

echo -en "\nSetting up new project: '$project_name'"
django-admin startproject --template=./rest_project_template $project_name

mkdir $project_name/requirements && pip freeze > $project_name/requirements/base.txt
touch $project_name/requirements/test.txt && echo "-r base.txt" > $project_name/requirements/test.txt
touch $project_name/requirements/local.txt && echo "-r test.txt" > $project_name/requirements/local.txt

all_hosts_path=$project_name/deploy/inventories/group_vars/all.yml
echo "docker_repo: \"{{ myrepo }}/$project_name\"" >> $all_hosts_path
echo "docker_image: \"{{ docker_repo }}:{{ docker_image_tag }}\"" >> $all_hosts_path

mv app_template $project_name/app_template

rm -r rest_project_template
