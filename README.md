
# TodoList using GraphQL

This is a todo list app that is built using Flutter, along with Riverpod for state management, and Strapi as the headless CMS. The GraphQL API of Strapi is used for performing the CRUD operations for this app.

With this app you can:
- Create a todo
- Mark or unmark a todo
- Delete a todo (long press)


## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

```bash
STRAPI_HOST_URL
```
This would usually be your localhost.



## Installation

- Clone this repository onto your local machine
- Create a new Strapi project
- Install the GraphQL plugin for Strapi in the project's directory
- Go to the admin panel of Strapi and create a new Collection type called Task with the given fields:
```
Title: String
Description: String
Completed: Boolean
```
-  Then Settings -> Users and permissions plugin -> Roles -> Public. Assign all the permission to the Tasks collection type.
- Back to the repository, initialise the environment variables
- Install the dependencies and run the app


## Screenshots
<img src=https://github.com/user-attachments/assets/cad674d8-48ad-4ef6-8844-4161ebe51b9d width=200px/>
<img src=https://github.com/user-attachments/assets/8d4f895e-6593-4342-9286-fe64698d18be width=200px/>
<img src=https://github.com/user-attachments/assets/767bcd6f-9d25-497f-b44b-82013dec12fe width=200px/>
