create database Examination_System_Requirements;
use Examination_System_Requirements
go
-------------------- instructor----------
create table Instructors(
inst_id varchar(10) primary key,
inst_name nvarchar(50) not null
)

----------------courses-------
go
create table Courses (
crs_id varchar(10) primary key ,
crs_name varchar(50) not null unique ,
inst_id varchar(10) foreign key references Instructors(inst_id) 
	ON DELETE SET NULL
)
-------------departments------------
create table Departments(
Dept_no varchar(10) primary key,
Dept_name varchar(50) not null unique
)
go
------------students------------------
create table Students (
st_id int primary key identity(1,1),
st_Fname varchar(50) not null,
st_Lname varchar(50) not null,
dept_no varchar(10) foreign key references Departments(dept_no) 
	ON DELETE SET NULL on update cascade
);

go 
---------------Student_courses----------
create table Student_courses(
crs_id varchar(10) foreign key references Courses(crs_id) ON DELETE CASCADE,
st_id int foreign key references Students(st_id) ON DELETE CASCADE,
PRIMARY KEY (crs_id, st_id),
);

go
--------------------topics-------
create table Topics (
topic_id varchar(10) primary key ,
topic_name varchar(50) not null unique ,
crs_id varchar(10) foreign key references Courses(crs_id) ON DELETE CASCADE not null
);

go
------------questions ----------------
create table Questions(
q_no int primary key ,
question varchar(255) not null unique,
topic_id varchar(10) foreign key references Topics(topic_id) ON DELETE CASCADE not null
);
go
-----------questions answers----------------
Create table Question_answers(
qa_id int identity(1,1),
qa_answer varchar(255) not null ,
qa_letter varchar(1) not null ,
qa_isTrue bit default(0),
q_no int foreign key references Questions(q_no) 
	ON DELETE CASCADE on update cascade not null, 
constraint C1 primary key(qa_id, q_no)
);

go
---------Exams -------------
create table Exams (
exam_id int primary key ,
crs_id varchar(10) foreign key references Courses(crs_id) ON DELETE CASCADE not null
);
go 

------------exam_ questions -------------
create table Exam_questions (
exam_id int foreign key references Exams(exam_id) on delete cascade,
q_no int foreign key references Questions(q_no) ,
PRIMARY KEY (exam_id, q_no)
)

go 

-------------Student_exams------------
create table Student_exams (
st_id int foreign key references Students(st_id) ON DELETE CASCADE,
exam_id int foreign key references Exams(exam_id) ,
grade varchar(50) not null,
primary key(st_id , exam_id)
)
go
------------Student_answers----------
create table Student_answers (
a_answer varchar(1) not null ,
st_id int foreign key references Students(st_id) on delete cascade,
exam_id int foreign key references Exams(exam_id),
q_no int foreign key references Questions(q_no),
correct int ,
primary key(st_id , exam_id , q_no)

)

