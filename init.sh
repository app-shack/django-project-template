set -e +o pipefail

echo -en "Collecting resources\n"

wget -q -O django-project-template.tar.gz https://github.com/app-shack/django-project-template/releases/download/v1.0.0/django-project-template.tar.gz

temp=`mktemp -d 2>/dev/null || mktemp -d -t 'dpr'`
tar -xzf django-project-template.tar.gz -C "$temp" --exclude "*/init.sh" --exclude ".gitignore" && \
    mv -n "$temp"/*/* . && \
    rm -r "$temp"
rm -f django-project-template.tar.gz

read -p "Enter new project name: " project_name

echo -en "Install Django\n"
pip install django

echo -en "\nSetting up new project: '$project_name'"
django-admin startproject --template=./rest_project_template $project_name

pip freeze > $project_name/requirements.txt

# `startproject` explicitly ignores hidden folders, unfortunately
cp -r rest_project_template/.circleci $project_name/.circleci
cp -r app_template $project_name/app_template

rm -r rest_project_template app_template
