USE Projetos

INSERT INTO Users (nameUser, username, passwordUser, email) VALUES 
('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')

INSERT INTO Projects (nameProject, descriptionProject, dateProject) VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '2014-12-09')

SELECT u.id, u.nameUser, u.email, p.id, p.descriptionProject, p.dateProject 
FROM Projects p INNER JOIN Users_Has_Projects up
ON p.id = up.projects_id
INNER JOIN Users u
ON u.id = up.users_id
WHERE p.nameProject LIKE '%Re-folha%' 


SELECT p.nameProject
FROM Projects p LEFT OUTER JOIN Users_Has_Projects up
ON p.id = up.projects_id
WHERE up.projects_id IS NULL


SELECT u.nameUser
FROM Users u LEFT OUTER JOIN Users_Has_Projects up
ON u.id = up.users_id
WHERE up.users_id IS NULL

SELECT * FROM Users
SELECT * FROM Projects
SELECT * FROM Users_Has_Projects