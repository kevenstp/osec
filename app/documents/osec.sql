    CREATE DATABASE IF NOT EXISTS ProgramPortal CHARACTER SET utf8 COLLATE utf8_general_ci;
    USE ProgramPortal;

    -- ############################################################################
    -- USAGE SQL USER
    -- ############################################################################
    DROP PROCEDURE IF EXISTS drop_user_if_exists;
    DELIMITER //
    CREATE PROCEDURE drop_user_if_exists()
      BEGIN
        DECLARE userCount BIGINT DEFAULT 0 ;
        SELECT COUNT(*) INTO userCount FROM mysql.user WHERE User = 'root-portal' and Host = '%';
        IF userCount > 0 THEN
          DROP USER 'root-portal'@'%' ;
        END IF;
      END//
    DELIMITER ;

    CALL drop_user_if_exists() ;
    DROP PROCEDURE drop_user_if_exists;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ProgramPortal.* TO 'root-portal'@'%' IDENTIFIED BY 'naXahYt3ggEa9yMN8';

    SET FOREIGN_KEY_CHECKS=0;

    DROP TRIGGER IF EXISTS after_exercise_insert;
    DROP TRIGGER IF EXISTS after_submission_update;
    DROP TRIGGER IF EXISTS after_submission_insert;
    DROP TRIGGER IF EXISTS before_reward_delete;
    DROP TRIGGER IF EXISTS after_reward_insert;

    DROP TABLE IF EXISTS StudentAnswer;
    DROP TABLE IF EXISTS QuizStudent;
    DROP TABLE IF EXISTS QuestionStudent;
    DROP TABLE IF EXISTS AnswerChoice;
    DROP TABLE IF EXISTS Question;
    DROP TABLE IF EXISTS Quiz;
    DROP TABLE IF EXISTS TeacherSessionCourse;
    DROP TABLE IF EXISTS BadgeUser;
    DROP TABLE IF EXISTS Badge;
    DROP TABLE IF EXISTS Reward;
    DROP TABLE IF EXISTS StudentReward;
    DROP TABLE IF EXISTS Reward;
    DROP TABLE IF EXISTS `Prior`;
    DROP TABLE IF EXISTS SessionCourse;
    DROP TABLE IF EXISTS Content;
    DROP TABLE IF EXISTS Goal;
    DROP TABLE IF EXISTS Notification;
    DROP TABLE IF EXISTS CompetencyContext;
    DROP TABLE IF EXISTS RealisationContext;
    DROP TABLE IF EXISTS ElementCriterion;
    DROP TABLE IF EXISTS PerformanceCriterion;
    DROP TABLE IF EXISTS CourseElement;
    DROP TABLE IF EXISTS CompetencyElement;
    DROP TABLE IF EXISTS Competency;
    DROP TABLE IF EXISTS SocialMedia;
    DROP TABLE IF EXISTS `Group`;
    DROP TABLE IF EXISTS `Session`;
    DROP TABLE IF EXISTS Course;
    DROP TABLE IF EXISTS Exam;
    DROP TABLE IF EXISTS UserRole;
    DROP TABLE IF EXISTS RolePermission;
    DROP TABLE IF EXISTS TeacherGroup;
    DROP TABLE IF EXISTS StudentGroup;
    DROP TABLE IF EXISTS GroupExercise;
    DROP TABLE IF EXISTS Restriction;
    DROP TABLE IF EXISTS Correction;
    DROP TABLE IF EXISTS Submission;
    DROP TABLE IF EXISTS SubmissionHistory;
    DROP TABLE IF EXISTS File;
    DROP TABLE IF EXISTS IndiceUser;
    DROP TABLE IF EXISTS Indice;
    DROP TABLE IF EXISTS HintUser;
    DROP TABLE IF EXISTS Hint;
    DROP TABLE IF EXISTS ExercisePreview; /* remove this line once it has been removed everywhere */
    DROP TABLE IF EXISTS Exercise;
    DROP TABLE IF EXISTS Period;
    DROP TABLE IF EXISTS Category;
    DROP TABLE IF EXISTS Student;
    DROP TABLE IF EXISTS Teacher;
    DROP TABLE IF EXISTS Permission;
    DROP TABLE IF EXISTS Role;
    DROP TABLE IF EXISTS `User`;
    DROP TABLE IF EXISTS `Transaction`;

    SET FOREIGN_KEY_CHECKS=1;

    CREATE TABLE IF NOT EXISTS User (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        username VARCHAR(255),
        password VARCHAR(255),
        firstName VARCHAR(255),
        lastName VARCHAR(255),
        email VARCHAR(255),
        profileImage VARCHAR(255),
        coverImage VARCHAR(255),
        quote VARCHAR(255),
        verified BOOLEAN,
        approved BOOLEAN,
        token VARCHAR(255),
        rememberMeToken VARCHAR(255),
        createdDate DATE,
        lastConnection TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS Role (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        name VARCHAR(255)
    );

    CREATE TABLE IF NOT EXISTS UserRole (
        userId INTEGER ,
        roleId INTEGER ,
        PRIMARY KEY (userId, roleId),
        FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (roleId) REFERENCES Role (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Permission (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        code VARCHAR(255),
        name VARCHAR(255),
        description TEXT
    );

    CREATE TABLE IF NOT EXISTS RolePermission (
        roleId INTEGER ,
        permissionId INTEGER ,
        PRIMARY KEY (roleId, permissionId),
        FOREIGN KEY (roleId) REFERENCES Role (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (permissionId) REFERENCES Permission (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Teacher (
        userId INTEGER PRIMARY KEY ,
        employeeNumber VARCHAR(4),
        officeNumber VARCHAR(4),
        FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Student (
        userId INTEGER PRIMARY KEY ,
        da VARCHAR(7),
        FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Category (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        name VARCHAR(255),
        acronym VARCHAR(5),
        color VARCHAR(7),
        textColor VARCHAR(7)
    );

    CREATE TABLE IF NOT EXISTS Course (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        categoryId INTEGER,
        description TEXT,
        name VARCHAR(255),
        code VARCHAR(10),
        sessionNumber INTEGER,
        theoryWeighting INTEGER,
        labWeighting INTEGER,
        homeworkWeighting INTEGER,
        icon VARCHAR(255),
        unit VARCHAR(225),
        objective TEXT,
        FOREIGN KEY (categoryId) REFERENCES Category (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS `Prior` (
        courseId INTEGER ,
        priorId INTEGER ,
        priorType VARCHAR(255),
        PRIMARY KEY (courseId, priorId),
        FOREIGN KEY (courseId) REFERENCES Course (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (priorId) REFERENCES Course (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS `Session` (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        season VARCHAR(10),
        `year` VARCHAR(4),
        isActive BOOLEAN
    );

    CREATE TABLE IF NOT EXISTS SessionCourse (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        courseId INTEGER ,
        sessionId INTEGER ,
        FOREIGN KEY (courseId) REFERENCES Course (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (sessionId) REFERENCES `Session` (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS TeacherSessionCourse (
        teacherId INTEGER ,
        sessionCourseId INTEGER ,
        PRIMARY KEY (teacherId, sessionCourseId),
        FOREIGN KEY (teacherId) REFERENCES Teacher (userId) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (sessionCourseId) REFERENCES SessionCourse (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS `Group` (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        number INTEGER,
        courseId INTEGER,
        sessionId INTEGER,
        FOREIGN KEY (courseId) REFERENCES Course (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (sessionId) REFERENCES Session (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS TeacherGroup (
        teacherId INTEGER ,
        groupId INTEGER ,
        PRIMARY KEY (teacherId, groupId),
        FOREIGN KEY (teacherId) REFERENCES Teacher (userId) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (groupId) REFERENCES `Group` (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS StudentGroup (
        studentId INTEGER ,
        groupId INTEGER ,
        credits INTEGER,
        PRIMARY KEY (studentId, groupId),
        FOREIGN KEY (studentId) REFERENCES Student (userId) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (groupId) REFERENCES `Group` (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Period (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        groupId INTEGER,
        room VARCHAR(6),
        day ENUM('Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi'),
        startTime TIME,
        endTime TIME,
        FOREIGN KEY (groupId) REFERENCES `Group` (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Exercise (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        title VARCHAR(255),
        description TEXT,
        example TEXT,
        exampleType VARCHAR (6),
        execution TEXT,
        difficulty FLOAT,
        enable BOOLEAN,
        weekNumber INTEGER,
        dateEnable TIMESTAMP,
        credits INTEGER
    );

    CREATE TABLE IF NOT EXISTS Hint (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        exerciseId INTEGER,
        description VARCHAR (512),
        cost INTEGER,
        FOREIGN KEY (exerciseId) REFERENCES Exercise (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS HintUser (
        userId INTEGER,
        hintId INTEGER,
        FOREIGN KEY (userId) REFERENCES `User` (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (hintId) REFERENCES Hint (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS File (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        size INTEGER,
        path VARCHAR(255),
        type VARCHAR(255),
        exerciseId INTEGER,
        categoryName ENUM('file', 'image', 'cover', 'imagePreview') DEFAULT 'file',
        FOREIGN KEY (exerciseId) REFERENCES Exercise (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS GroupExercise (
        groupId INTEGER ,
        exerciseId INTEGER ,
        activationDate TIMESTAMP,
        possibleDueDate TIMESTAMP,
        PRIMARY KEY (groupId, exerciseId),
        FOREIGN KEY (groupId) REFERENCES `Group` (id) ON DELETE CASCADE ON UPDATE CASCADE ,
        FOREIGN KEY (exerciseId) REFERENCES Exercise (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Submission (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        exerciseId INTEGER,
        studentId INTEGER,
        date TIMESTAMP,
        answerPath VARCHAR(255),
        comments TEXT,
        FOREIGN KEY (exerciseId) REFERENCES Exercise (id) ON UPDATE CASCADE ON DELETE CASCADE ,
        FOREIGN KEY (studentId) REFERENCES Student (userId) ON UPDATE CASCADE ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Correction (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        submissionId INTEGER NOT NULL,
        date TIMESTAMP,
        result BOOLEAN,
        comments TEXT,
        FOREIGN KEY (submissionId) REFERENCES Submission (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Restriction (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        courseId INTEGER,
        theoryRoom TEXT,
        labRoom TEXT,
        comments TEXT,
        priority INTEGER,
        timeSlot TEXT,
        FOREIGN KEY (courseId) REFERENCES Course (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Exam (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        groupId INT,
        nbPeriod TEXT,
        comments TEXT,
        FOREIGN KEY (groupId) REFERENCES `Group` (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS SocialMedia (
        userId INTEGER PRIMARY KEY,
        github TEXT,
        facebook TEXT,
        instagram TEXT,
        twitter TEXT,
        linkedIn TEXT,
        discord TEXT,
        steam TEXT,
        twitch TEXT,
        FOREIGN KEY (userId) REFERENCES User (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE EVENT IF NOT EXISTS EnableExercisesByDate
    ON SCHEDULE EVERY 24 HOUR
    ON COMPLETION NOT PRESERVE ENABLE DO
    UPDATE Exercise
    SET enable = 1
    WHERE dateEnable <= NOW();

    CREATE EVENT IF NOT EXISTS DeleteNotVerifiedAccount
    ON SCHEDULE EVERY 24 HOUR
    ON COMPLETION NOT PRESERVE ENABLE DO
    DELETE FROM `User`
    WHERE createdDate <= GETDATE() + 4 AND verified = 0;

    SET GLOBAL event_scheduler = ON;

    CREATE TABLE IF NOT EXISTS Competency (
        code VARCHAR(4) PRIMARY KEY,
        title TEXT
    );

    CREATE TABLE IF NOT EXISTS CompetencyElement (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        title TEXT,
        competencyCode VARCHAR(4),
        FOREIGN KEY (competencyCode) REFERENCES Competency (code) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS CourseElement (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        courseId INTEGER,
        elementId INTEGER,
        FOREIGN KEY (elementId) REFERENCES CompetencyElement (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (courseId) REFERENCES Course (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS PerformanceCriterion (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        description TEXT
    );

    CREATE TABLE IF NOT EXISTS ElementCriterion (
        elementId INTEGER,
        criterionId INTEGER,
        PRIMARY KEY (elementId, criterionId),
        FOREIGN KEY (elementId) REFERENCES CompetencyElement (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (criterionId) REFERENCES PerformanceCriterion (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS RealisationContext (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        description TEXT
    );

    CREATE TABLE IF NOT EXISTS CompetencyContext (
        contextId INTEGER,
        competencyCode VARCHAR(4),
        PRIMARY KEY (contextId, competencyCode),
        FOREIGN KEY (competencyCode) REFERENCES Competency (code) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (contextId) REFERENCES RealisationContext (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Goal (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        title TEXT,
        courseId INTEGER,
        elementId INTEGER,
        FOREIGN KEY (courseId) REFERENCES Course (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (elementId) REFERENCES CompetencyElement (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Content (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        description TEXT,
        goalId INTEGER,
        FOREIGN KEY (goalId) REFERENCES Goal (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS SubmissionHistory (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        submissionId INTEGER,
        correctionTime TIMESTAMP,
        FOREIGN KEY (submissionId) REFERENCES Submission (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Notification (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        userId INTEGER,
        content TEXT,
        isRead TIMESTAMP NULL ,
        FOREIGN KEY (userId) REFERENCES `User`(id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Reward (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        courseId INTEGER,
        title TEXT,
        price INTEGER,
        enable BOOLEAN,
        FOREIGN KEY (courseId) REFERENCES Course(id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Badge (
        id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
        icon VARCHAR(255),
        title VARCHAR(255),
        description TEXT
    );

    CREATE TABLE IF NOT EXISTS BadgeUser (
        badgeId INTEGER,
        userId INTEGER,
        `rank` VARCHAR(255),
        PRIMARY KEY (badgeId, userId),
        FOREIGN KEY (badgeId) REFERENCES Badge (id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (userId) REFERENCES Student (userId) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS StudentReward (
        studentId INTEGER,
        rewardId INTEGER,
        taken BOOLEAN,
        PRIMARY KEY (studentId, rewardId),
        FOREIGN KEY (studentId) REFERENCES Student(userId) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (rewardId) REFERENCES Reward(id) ON UPDATE CASCADE ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Quiz (
        code VARCHAR(8) PRIMARY KEY,
        title VARCHAR(255),
        isStarted BOOLEAN,
        courseId INTEGER,
        FOREIGN KEY (courseId) REFERENCES Course(id) ON UPDATE CASCADE ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Question (
        id INTEGER PRIMARY KEY AUTO_INCREMENT,
        title TEXT,
        explanation TEXT,
        type ENUM('choices', 'trueFalse', 'shortAnswer'),
        quizCode VARCHAR(8),
        isActive BOOLEAN,
        FOREIGN KEY (quizCode) REFERENCES Quiz(code) ON UPDATE CASCADE ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS AnswerChoice (
        id INTEGER PRIMARY KEY AUTO_INCREMENT,
        description VARCHAR(255),
        isGood BOOLEAN,
        questionId INTEGER,
        FOREIGN KEY (questionId) REFERENCES Question(id) ON UPDATE CASCADE ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS QuizStudent (
        studentId INTEGER,
        quizCode VARCHAR(8),
        isActive BOOLEAN,
        PRIMARY KEY (studentId, quizCode),
        FOREIGN KEY (studentId) REFERENCES Student (userId) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (quizCode) REFERENCES Quiz (code) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS StudentAnswer (
        studentId INTEGER,
        questionId INTEGER,
        answer VARCHAR(255),
        isGood BOOLEAN,
        PRIMARY KEY (studentId, questionId),
        FOREIGN KEY (studentId) REFERENCES Student (userId) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (questionId) REFERENCES Question (id) ON DELETE CASCADE ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS `Transaction` (
        transactionId INTEGER AUTO_INCREMENT,
        studentId INTEGER,
        date TIMESTAMP,
        fluctuation DOUBLE,
        currentCredit DOUBLE,
        description VARCHAR(255),
        PRIMARY KEY (transactionId),
        FOREIGN KEY (studentId) REFERENCES Student(userId) ON UPDATE CASCADE ON DELETE CASCADE
    );

    DELIMITER //
        CREATE TRIGGER after_exercise_insert AFTER INSERT ON Exercise FOR EACH ROW
        BEGIN
            INSERT INTO Notification (userId, content, isRead)
            SELECT S.userId, 'Vous avez un nouvel exercice', null
            FROM Student S;
        END; //
         CREATE TRIGGER after_correction_update AFTER UPDATE ON Correction FOR EACH ROW
         BEGIN
             IF (OLD.result IS NULL AND (NEW.result = true OR NEW.result = false)) THEN
                 SET @student_id := (SELECT studentId FROM Submission WHERE id = NEW.submissionId ORDER BY `date` DESC LIMIT 1);
                 INSERT INTO Notification (userId, content, isRead)
                 VALUES (@student_id, 'Vous avez une nouvelle correction', null);
                 IF (NEW.result = true) THEN
                     SET @exercise_credits := (SELECT Exercise.credits
                                                             FROM Exercise
                                                             WHERE id = (SELECT exerciseId FROM Submission WHERE id = NEW.submissionId));
                     SET @group_id := (SELECT SG.groupId
                                      FROM Exercise E
                                               JOIN GroupExercise GE ON E.id = GE.exerciseId
                                               JOIN `Group` G ON GE.groupId = G.id
                                               JOIN (SELECT * FROM StudentGroup) as SG ON G.id = SG.groupId
                                      WHERE SG.studentId = @student_id
                                     LIMIT 1);
                     UPDATE StudentGroup SET credits =
                                                 (credits + @exercise_credits)
                     WHERE studentId = @student_id
                       AND groupId = @group_id;
                     INSERT INTO `Transaction` (transactionId, studentId, date, fluctuation, currentCredit, description)
                     VALUES (null, @student_id, NOW(), @exercise_credits, (SELECT credits
                                                                                 FROM StudentGroup
                                                                                 WHERE studentId = @student_id AND groupId = @group_id),
                     CONCAT('Vous avez reçu ', @exercise_credits, 'c par l''accomplissement de l''exercice ', (SELECT Exercise.title
                                                                         FROM Exercise
                                                                         WHERE id = (SELECT exerciseId FROM Submission WHERE id = NEW.submissionId)), '.'));
                 END IF;
             END IF;
         END; //
        CREATE TRIGGER after_submission_insert AFTER INSERT ON Submission FOR EACH ROW
        BEGIN
            INSERT INTO Notification (userId, content, isRead)
            SELECT TG.teacherId, 'Vous avez une nouvelle remise d''exercice', null
            FROM Submission S
                 JOIN Exercise E ON S.exerciseId = E.id
                 JOIN GroupExercise GE ON GE.exerciseId = E.id
                 JOIN `Group` G ON GE.groupId = G.id
                 JOIN TeacherGroup TG ON G.id = TG.groupId
            WHERE S.id = NEW.exerciseId;
        END; //
        CREATE TRIGGER before_reward_delete BEFORE DELETE ON Reward FOR EACH ROW
        BEGIN
            UPDATE StudentGroup SET credits = (credits + OLD.price)
            WHERE groupId IN
                (SELECT G.id
                    FROM Course C
                    JOIN `Group` G ON C.id = G.courseId
                    JOIN (SELECT * FROM StudentGroup) as SG ON G.id = SG.groupId
                    JOIN StudentReward SR ON SG.studentId = SR.studentId
                WHERE C.id = OLD.courseId AND SR.taken = true);
        END ; //
        CREATE TRIGGER after_reward_insert AFTER INSERT ON Reward FOR EACH ROW
        BEGIN
            INSERT INTO StudentReward (studentId, rewardId, taken)
            SELECT SG.studentId, NEW.id, false
            FROM Course C
                JOIN `Group` G ON C.id = G.courseId
                JOIN StudentGroup SG ON G.id = SG.groupId
            WHERE C.id = NEW.courseId;
        END; //
        CREATE TRIGGER after_student_reward_update AFTER UPDATE ON StudentReward FOR EACH ROW
        BEGIN
            IF (OLD.taken = false AND New.taken = true) THEN
                INSERT INTO Notification (userId, content, isRead)
                SELECT TG.teacherId, CONCAT(U.firstName,' ',U.lastName, ' a pris la récompense : ',R.title), null
                FROM User U
                         JOIN Student S ON U.id = S.userId
                         JOIN StudentReward SR ON S.userId = SR.studentId
                         JOIN Reward R ON SR.rewardId = R.id
                         JOIN Course C ON R.courseId = C.id
                         JOIN `Group` G ON C.id = G.courseId
                         JOIN TeacherGroup TG ON G.id = TG.groupid
                WHERE U.id = NEW.studentId AND R.id = NEW.rewardId
                GROUP BY TG.teacherId;
            END IF ;
        END; //
    DELIMITER ;

    INSERT INTO User (id, username, password, firstName, lastName, email, profileImage, coverImage, quote, verified, approved, token) VALUES
    (NULL, 'Admin', '$2y$10$80pWUx0bFUQvOZeXaPLNweo27CBEMVqpZHbru74ZtURrccfw4bJkC', 'Admin', 'Admin', 'admin@admin.ca', 'adminProfil.png', 'adminWallpaper.jpeg', 'Access Denied', 1, 1, NULL), /*Admin1234*/
    (NULL, 'Dadajuice', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'David', 'Tucker', 'Dtucker@cegepst.qc.ca', 'bocKsuICK7fzlZ7pAkTvuvuAGyGjrd94.jpg', 'QZEeBXjwaN8XxyHmxK3WxSZtTL3Eio0r.jpg', 'Ce sera le TP le plus facile de votre vie', 1, 1, NULL), /*Omega123*/
    (NULL, 'GuyGuy', '$2y$10$zx673ekyUo9xMg1GNGVe5Odu6LEgdk6OG8CZ/53K1GS2j7YLFmMtK', 'Guylaine', 'Peloquin', 'GPeloquin@cegepst.qc.ca', 'guylaineProfil.jpg', 'bBdz9Gh1W9DdQ6iZ7i3vZ1LDVal4qWHU.jpg', 'On va faire la trace!', 1, 1, NULL), /*Delta420*/
    (NULL, 'Vov', '$2y$10$Q0yPMpMSVkLCErVthDJx1O6u4Gu1oGS1pZPHXADOHAaHrQlzgUj0S', 'Alexandre', 'Vovan', 'AVovan@cegepst.qc.ca', 'vovanProfil.jpg', 'vovanWallpaper.jpg', 'Google it.', 1, 1, NULL), /*AlphaCharlie69*/
    (NULL, 'FoxerQuatreVingtDix', '$2y$10$YKe8pwE7HFY0KtBrj4c2a.8F5QwjNdJTxBhLMEus.iinyUAHOfFZu', 'Jordan', 'Rioux', 'JRioux@cegepst.qc.ca', 'jordyProfil.jpg', 'jordyWallpaper.jpg', 'Marc, viens-tu gamer ?', 1, 1, NULL),/*LooLove4Ever*/
    (NULL, 'LudoB99', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'Ludovic', 'Belzile', 'Ludovic@fake.com', 'adminProfil.png', 'adminWallpaper.jpeg', ' quote', 1, 1, NULL), /*Omega123*/
    (NULL, 'PizzaJulie', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'Guillaume', 'Dufour', 'Guillaume@fake.com', 'adminProfil.png', 'adminWallpaper.jpeg', ' quote', 1, 1, NULL), /*Omega123*/
    (NULL, 'RevyMan', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'Timothy', 'Farley', 'Timothy@fake.com', 'adminProfil.png', 'adminWallpaper.jpeg', ' quote', 1, 1, NULL), /*Omega123*/
    (NULL, 'JessyNizz', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'Charles', 'Bres', 'Charles@fake.com', 'adminProfil.png', 'adminWallpaper.jpeg', ' quote', 1, 1, NULL), /*Omega123*/
    (NULL, 'HolyJord', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'Marc-Andre', 'Doyon', 'Marc@fake.com', 'adminProfil.png', 'adminWallpaper.jpeg', ' quote', 1, 1, NULL), /*Omega123*/
    (NULL, 'Alophes', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'Bryan', 'Gasse', 'Bryan@fake.com', 'adminProfil.png', 'adminWallpaper.jpeg', ' quote', 1, 1, NULL), /*Omega123*/
    (NULL, 'Mindflares', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'Dave', 'Beauchesne', 'Dave@fake.com', 'adminProfil.png', 'adminWallpaper.jpeg', ' quote', 1, 0, NULL), /*Omega123*/
    (NULL, 'Kogi', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'Jonathan', 'deschenes', 'Jonathan@fake.com', 'adminProfil.png', 'adminWallpaper.jpeg', ' quote', 1, 0, NULL), /*Omega123*/
    (NULL, 'Simon', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'Simon', 'Dufault', 'Simon@fake.com', 'adminProfil.png', 'adminWallpaper.jpeg', ' quote', 1, 0, NULL), /*Omega123*/
    (NULL, 'RFarley', '$2y$10$VYp2waY1UNBAQy2j7pkYt.rcbUFYiaYarsbb2rmLtrR3Vs6lj9jgK', 'Richard', 'Farley', 'RFarley@cegepst.qc.ca', 'oJRcIrqJCLKLgTgvBe2PfnWzZT97v1iR.jpg', 'HdMP14gK3eyq6f4UrII1oCLFwdBsp6v6.jpg', 'Si faut être la a 9h arrive a 8h45', 1, 1, NULL); /*Omega123*/

    INSERT INTO Teacher (userId, employeeNumber, officeNumber) VALUES
    (2, '1234', '1234'),
    (3, '1234', '1234');

    INSERT INTO Student (userId, da) VALUES
    (6, '5413724'),
    (7, '7314037'),
    (8, '1862978'),
    (9, '6793548'),
    (10, '6965047'),
    (11, '0550016'),
    (12, '8889263'),
    (13, '3563326'),
    (14, '0463056');

    INSERT INTO Role (id, name) VALUES
    (1, 'admin'),
    (2, 'professeur'),
    (3, 'etudiant'),
    (4, 'assistant-professeur');

    INSERT INTO UserRole (userId, roleId) VALUES
    (1, 2),
    (2, 2),
    (3, 2),
    (4, 2),
    (5, 2),
    (6, 3),
    (7, 3),
    (8, 3),
    (9, 3),
    (10, 3),
    (11, 3),
    (12, 3),
    (13, 3),
    (14, 3);

    INSERT INTO Permission (id, code, name, description) VALUES
    (1,'ADD_STU', 'Ajouter un étudiant', 'Créer un étudiant dans la base de données'),
    (2,'MOD_STU',  'Modifier un étudiant', 'Modifier un étudiant dans la base de données'),
    (3,'DEL_STU',  'Supprimer un étudiant', 'Supprimer un étudiant dans la base de données'),
    (4,'ADD_TEA',  'Ajouter un professeur', 'Ajouter un professeur dans la base de données'),
    (5,'MOD_TEA',  'Modifier un professeur', 'Modifier un professeur dans la base de données'),
    (6,'DEL_TEA',  'Supprimer un professeur', 'Supprimer un professeur dans la base de données'),
    (7,'ADD_EXE',  'Ajouter un exercice', 'Ajouter un exercice dans la base de données'),
    (8,'MOD_EXE',  'Modifier un exercice', 'Modifier un exercice dans la base de données'),
    (9,'DEL_EXE',  'Supprimer un exercice', 'Supprimer un exercice dans la base de données'),
    (10,'ADD_COU',  'Ajouter un cours', 'Ajouter un cours dans la base de données'),
    (11,'MOD_COU',  'Modifier un cours', 'Modifier un cours dans la base de données'),
    (12,'DEL_COU',  'Supprimer un cours', 'Supprimer un cours dans la base de données'),
    (13,'ADD_GRP',  'Ajouter un groupe', 'Ajouter un groupe dans la base de données'),
    (14,'MOD_GRP',  'Modifier un groupe', 'Modifier un groupe dans la base de données'),
    (15,'DEL_GRP',  'Supprimer un groupe', 'Supprimer un groupe dans la base de données'),
    (16,'ADD_SUB',  'Ajouter un soumission', 'Ajouter un soumission dans la base de données'),
    (17,'MOD_SUB',  'Modifier un soumission', 'Modifier un soumission dans la base de données'),
    (18,'DEL_SUB', 'Supprimer un soumission', 'Supprimer un soumission dans la base de données');

    INSERT INTO RolePermission (roleId, permissionId) VALUES
    (1, 1),(1, 2),(1, 3),(1, 4),(1, 5),(1, 6),(1, 7),(1, 8),(1, 9),(1, 10),(1, 11),(1, 12),(1, 13),(1, 14),(1, 15),
    (2, 1),(2, 2),(2, 3),(2, 7),(2, 8),(2, 9),(2, 10),(2, 11),(2, 12),(2, 13),(2, 14),(2, 15),
    (3, 2),(3, 16),(3, 17),(3, 18),
    (4, 1),(4, 2),(4, 3),(4, 7),(4, 8),(4, 9),(4, 13),(4, 14),(4, 15),(4, 16),(4, 17),(4, 18);

    INSERT INTO Category (id, name, acronym, color, textColor) VALUES
    (1, 'Profession', 'T', '#E1E5CF', '#FFF'),
    (2, 'Web', 'U', '#C6D7E6', '#FFF'),
    (3, 'Conception', 'R,B', '#FEFF54', '#000'),
    (4, 'Programmation', 'J', '#F6C343', '#FFF'),
    (5, 'Mobile', 'A', '#EA3323', '#FFF'),
    (6, 'Exploitation', 'X', '#CCC7D9', '#FFF'),
    (7, 'Contributive', '', '#EFEFEF', '#000'),
    (8, 'Intégrateur', 'M', '#000000', '#FFF');

    INSERT INTO `Course` (`id`, `categoryId`, `description`, `name`, `code`, `sessionNumber`, `theoryWeighting`, `labWeighting`, `homeworkWeighting`, `icon`, `unit`, `objective`) VALUES
    (1, 2, 'Un beau cours de Web', 'Web 1 - Langages de présentation', '420-1U3-SO', 1, 1, 2, 2, '/assets/course_image/420-1U3-SO.svg', null, null),
    (2, 2, 'Un beau cours de Web part. 2', 'Web 2 - Développement front-end', '420-2U3-SO', 2, 1, 2, 1, '/assets/course_image/420-2U3-SO.svg', null, null),
    (3, 2, 'Un beau cours de Web part. 3', 'Web 3 - Dév. front-end avancé et intro. back-end', '420-3U3-SO', 3, 1, 2, 2, '/assets/course_image/420-3U3-SO.svg', null, null),
    (4, 4, 'Un beau cours de Programmation', 'Paradigme de prog. orientée objet 1', '420-2J4-SO', 2, 2, 2, 2, '/assets/course_image/420-2J4-SO.svg', null, null),
    (6, 1, 'lkdsf', 'Introduction aux professions des TI', '420-1T4-SO', 1, 2, 2, 2, '/assets/course_image/420-1T4-SO.svg', null, null),
    (7, 1, 'fhkjfhg', 'Veille technologique', '420-6T3-SO', 6, 1, 2, 4, '/assets/course_image/420-6T3-SO.svg', null, null),
    (9, 6, 'lkdjf', 'IoT I - Systèmes embarqués et prototypage', '420-2X3-SO', 2, 2, 1, 2, '/assets/course_image/420-2X3-SO.svg', null, null),
    (10, 6, 'kldj', 'IoT II - Télécommuniations et sécurité', '420-3X3-SO', 3, 1, 2, 1, '/assets/course_image/420-3X3-SO.svg', null, null),
    (11, 6, 'kdjf', 'Internet et services réseaux', '420-4X4-SO', 4, 2, 2, 1, '/assets/course_image/420-4X4-SO.svg', null, null),
    (12, 6, 'kjghjg', 'Écosystème connecté', '420-5X7-SO', 5, 3, 4, 2, '/assets/course_image/420-5X7-SO.svg', null, null),
    (13, 5, 'kjhkjh', 'Développement d''une application mobile I', '420-3A4-SO', 3, 2, 2, 2, '/assets/course_image/420-3A4-SO.svg', null, null),
    (14, 5, 'kjh', 'Développement d''une application mobile II', '420-4A4-SO', 4, 2, 2, 2, '/assets/course_image/420-4A4-SO.svg', null, null),
    (15, 2, 'hjghj', 'Web IV - Développement back-end et sécurité', '420-4U4-SO', 4, 2, 2, 2, '/assets/course_image/420-4U4-SO.svg', null, null),
    (16, 2, 'jkhdfjkhdsf', 'Web V - Paradigme de prog. fonct. et intég. back-end', '420-5U3-SO', 5, 1, 2, 2, '/assets/course_image/420-5U3-SO.svg', null, null),
    (17, 3, 'sdf', 'Base de données I - Exploitation', '420-2R3-SO', 2, 1, 2, 1, '/assets/course_image/420-2R3-SO.svg', null, null),
    (18, 3, 'fdgdfg', 'Base de données II - Optimisation', '420-3R3-SO', 3, 1, 2, 2, '/assets/course_image/420-3R3-SO.svg', null, null),
    (19, 3, 'jghjg', 'Base de données III - Conception', '420-4R3-SO', 4, 1, 2, 2, '/assets/course_image/420-4R3-SO.svg', null, null),
    (20, 3, 'jhgjhg', 'Tech. de développement d''un système', '420-4B5-SO', 4, 2, 3, 2, '/assets/course_image/420-4B5-SO.svg', null, null),
    (21, 3, 'hjghjg', 'Projet d''intégration', '420-5R0-SO', 5, 3, 7, 2, '/assets/course_image/420-5R0-SO.svg', null, null),
    (22, 3, 'jhgjh', 'Implantation et maintenance d''une app.', '420-6R5-SO', 6, 1, 4, 3, '/assets/course_image/420-6R5-SO.svg', null, null),
    (23, 4, 'kjghjg', 'Développement d''un jeu vidéo', '420-5J3-SO', 5, 1, 2, 2, '/assets/course_image/420-5J3-SO.svg', null, null),
    (24, 4, 'kdf', 'Algorithmes et intro. à la programmation', '420-1J6-SO', 1, 3, 3, 2, '/assets/course_image/420-1J6-SO.svg', null, null),
    (25, 4, 'kljer', 'Paradigme de prog. procédurale', '420-2J6-SO', 2, 3, 3, 2, '/assets/course_image/420-2J6-SO.svg', null, null),
    (26, 4, 'yuyt', 'Paradigme de prog. orientée objet II', '420-3J5-SO', 3, 2, 3, 2, '/assets/course_image/420-3J5-SO.svg', null, null),
    (27, 4, 'kjhh', 'Paradigme de prog. orientée objet III', '420-4J4-SO', 4, 2, 2, 2, '/assets/course_image/420-4J4-SO.svg', null, null);

    INSERT INTO Restriction (id, courseId, theoryRoom, labRoom, comments, priority, timeSlot) VALUES
    (NULL, 1, 'C-1209', 'C-2109', 'Il faut de belles chaise de gaming', 5, '2 periodes de 5 heures'),
    (NULL, 2, 'C-1201', 'C-2101', 'Il faut avoir un beau sourire et du PFK', 5, '2 periodes de deux heures');

    INSERT INTO Session (id, season, year, isActive) VALUES
    (DEFAULT, 'Automne', '2019', TRUE),
    (DEFAULT, 'Hiver', '2020', FALSE),
    (DEFAULT, 'Été', '2020', FALSE);

    INSERT INTO `Group` (id, number, courseId, sessionId) VALUES
    (1, 1, 1, 2),
    (2, 2, 1, 2),
    (3, 1, 2, 2),
    (4, 2, 2, 2);

    INSERT INTO TeacherGroup (teacherId, groupId) VALUES
    (2, 1),
    (2, 2),
    (3, 3),
    (3, 4);

    INSERT INTO StudentGroup (studentId, groupId, credits) VALUES
    (6, 1, 0),
    (6, 3, 1000),
    (7, 2, 400),
    #(10, 2, 0),
    (7, 4, 350),
    (11, 1, 2000);

    INSERT INTO Period (id, groupId, room, day, startTime, endTime) VALUES
    (1, 1, 'C-1201', 'Lundi', '08:00:00', '11:30:00'),
    (2, 2, 'C-1201', 'Mardi', '12:35:00', '14:15:00'),
    (3, 3, 'C-1201', 'Mercredi', '13:35:00', '15:15:00'),
    (4, 4, 'C-1201', 'Jeudi', '15:55:00', '18:00:00');

    INSERT INTO Exercise (id, title, description, example, exampleType, execution, difficulty, enable, weekNumber, credits) VALUES
    (1, 'Aeroport', 'Faire un exercice par rapport à un aeroport.', null, 'css', null, 4.0, true, 1, 100),
    (2, 'Calcul Circonference', 'Faire la function.', null, 'txt', null, 1.0, true, 1, 0),
    (3, 'Facture', 'Faire des factures', null, 'txt', null, 1.0, true, 2, 0),
    (4, 'Jeux Video', 'Faire un jeu de guerre', null, 'txt', null, 5.0, true, 1, 500),
    (100, 'HistoriqueD', 'Voir un historique', 'Fichier date', 'txt', 'Une exécution', 5.0, true, 1, 0),
    (5, 'Treeview', 'Vous devez creer un beau treeview', null, 'txt', null, 5.0, true, 10, 0);

    INSERT INTO Hint (exerciseId, description, cost) VALUES
    (1, 'As-tu essayé la balise <code>.', 5),
    (1, 'Le mot clé extends en java est synonyme d''heritage.', 10);

    INSERT INTO HintUser(hintId, userId) VALUES
    (1, 4),
    (2, 4);

    INSERT INTO Submission (id, exerciseId, studentId, date, answerPath, comments) VALUES
    (1, 1, 11, '2020-01-01 12:00:00', '/media/sf_www/portail-programme/app/../data/student/CustomRule.php', ''),
    (2, 2, 11, '2020-01-01 12:00:00', '/media/sf_www/portail-programme/app/../data/student/test.java', 'Le code le plus sale que j''ai vue de ma vie'),
    (3, 3, 11, '2020-01-01 12:00:00', '/media/sf_www/portail-programme/app/../data/student/test.java', 'Un code monsieur'),
    (100, 100, 11, '2020-01-01 12:00:00', '/media/sf_www/portail-programme/app/../data/student/test.java', 'Une belle historique'),
    (4, 4, 11, '2020-01-01 12:00:00', '/media/sf_www/portail-programme/app/../data/student/test.java', '');

    INSERT INTO GroupExercise (groupId, exerciseId, activationDate, possibleDueDate) VALUES
    (1, 1, '2020-02-02 08:00:00', '2021-02-02 17:00:00'),
    (4, 2, '2020-02-02 08:00:00', '2021-02-02 17:00:00'),
    (1, 3, '2020-02-02 08:00:00', '2021-02-02 17:00:00'),
    (1, 4, '2020-02-02 08:00:00', '2021-02-02 17:00:00'),
    (1, 100, '2020-02-02 08:00:00', '2021-02-02 17:00:00'),
    (1, 5, '2020-02-02 08:00:00', '2021-02-02 17:00:00');

    INSERT INTO Exam (id, groupId, nbPeriod, comments) VALUES
    (DEFAULT, 1, '3', 'C-4534'),
    (DEFAULT, 2, '5', 'C-4534'),
    (DEFAULT, 3, '1', 'C-4534'),
    (DEFAULT, 4, '6', 'C-4534');

    INSERT INTO SocialMedia (userId, github, facebook, instagram, twitter, linkedIn, discord, steam, twitch) VALUES
    (2, null, 'https://www.facebook.com/david.tucker.9889', 'https://www.instagram.com/dadajuice/', null, null, null, null, null),
    (3, null, 'https://www.facebook.com/guylaine.peloquin', null, null, null, null, null, null);

    INSERT INTO Competency (code, title) VALUES
    ('0000', 'Traiter l''information relative aux réalités du milieu du travail en informatique'),
    ('00Q1', 'Effectuer l''installation et la gestion d''ordinateurs'),
    ('00Q2', 'Utiliser des langages de programmation'),
    ('00Q3', 'Résoudre des problèmes d''information avec les mathématiques'),
    ('00Q4', 'Exploiter des logiciels de bureautique'),
    ('00Q5', 'Effectuer le déploiement d''un réseau informatique local'),
    ('00Q6', 'Exploiter les principes de la programmation orientée objet'),
    ('00Q7', 'Exploiter un système de gestion de base de données'),
    ('00Q8', 'Effectuer des opérations de prévention en matière de sécurité de l''information'),
    ('00SE', 'Interagir dans un contexte professionnel'),
    ('00SF', 'Évaluer des composants logiciels et matériels'),
    ('00SG', 'Fournir du soutien informatique aux utilisatrices et utilisateurs'),
    ('00SH', 'S''adapter à des technologies informatiques'),
    ('00SR', 'Effectuer le développement d''applications natives sans base de données'),
    ('00SS', 'Effectuer le développement d''applications natives avec base de données'),
    ('00SU', 'Effectuer le développement d''applications Web transactionnelles'),
    ('00SV', 'Effectuer le développement de services d''échange de données'),
    ('00SW', 'Effectuer le développement d''application de jeu ou de simulation'),
    ('00SX', 'Effectuer le développement d''applications pour des objets connectés'),
    ('00SY', 'Collaborer à la conception d''applications');

    INSERT INTO CompetencyElement (id, title, competencyCode) VALUES
    (6, '1. Rechercher de l''information sur les professions et les milieux de travail en informatique', '0000'),
    (7, '2. Analyser l''information sur les entreprises et les établissements embauchant des techniciennes et techniciens en informatique', '0000'),
    (8, '3. Analyser l''information sur la profession de technicienne et technicien en informatique', '0000'),
    (27, '1. Créer la base de données', '00Q7'),
    (28, '2. Formuler des requêtes de lecture, d''insertion, de modification et de suppression de données', '00Q7'),
    (29, '3. Assurer la confidentialité et la cohérence des données', '00Q7'),
    (30, '4. Programmer des traitements de données automatisés', '00Q7'),
    (31, '5. Sauvegarder et restaurer la base de données', '00Q7'),
    (32, '1. Cerner les exigences techniques d''un projet de développement ou de déploiement', '00SF'),
    (33, '2. Recherche des composants logiciels et matériels', '00SF'),
    (34, '3. Formuler des avis sur les composants logiciels et matériels', '00SF'),
    (35, '1. Préparer l''ordinateur', '00Q1'),
    (36, '2. Installer le système d''exploitation', '00Q1'),
    (37, '3. Installer des applications', '00Q1'),
    (38, '4. Effectuer des tâches de gestion du système d''exploitation', '00Q1'),
    (39, '1. Analyser le projet de développement de l''application', '00SR'),
    (40, '2. Préparer l''environnement de développement informatique', '00SR'),
    (41, '3. Générer ou programmer l''interface graphique', '00SR'),
    (42, '4. Programmer la logique applicative', '00SR'),
    (43, '5. Contrôler la qualité de l''application', '00SR'),
    (44, '6. Participer à la mise en service de l''application', '00SR'),
    (45, '7. Rédiger la documentation', '00SR'),
    (46, '1. Établir des relations professionnelles avec des utilisatrices ou utilisateurs, ainsi que des clientes ou clients', '00SE'),
    (47, '2. Travailler au sein d''une équipe multidisciplinaire', '00SE'),
    (48, '3. Se situer au regard des obligations légales et des règles d''éthique professionnelle', '00SE'),
    (49, '1. Préciser le besoin', '00SG'),
    (50, '2. Assister des utilisatrices et des utilisateurs en ce qui a trait à l''emploi d''un ordinateur et de logiciels', '00SG'),
    (51, '3. Préparer les documents d''aide aux utilisatrices et utilisateurs', '00SG'),
    (52, '4. Effectuer un suivi sur le soutien approprié', '00SG'),
    (53, '1. Participer à l''élaboration du cahier des charges fonctionnel', '00SY'),
    (54, '2. Participer à la conception générale des applications', '00SY'),
    (55, '3. Effectuer la conception détaillée', '00SY'),
    (56, '4. Produire des documents de conception', '00SY'),
    (57, '1. Effectuer une veilletechnologique', '00SH'),
    (58, '2. Expérimenter une technologie matérielle ou logicielle', '00SH'),
    (59, '3. Formuler des avis sur la technologie', '00SH'),
    (60, '1. Définir les caractéristiques du réseau informatique local', '00Q5'),
    (61, '2. Installer les dispositions d''interconnexions du réseau local', '00Q5'),
    (62, '3. Connecter les ordinateurs au réseau local', '00Q5'),
    (63, '4. Installer des services de partage de ressources', '00Q5'),
    (64, '5. Mettre en service le réseau local', '00Q5'),
    (65, '1. Analyser des risques en matière de sécurité de l''information', '00Q8'),
    (66, '2. Appliquer des mesures de sécurité reconnues pour protéger le réseau', '00Q8'),
    (67, '3. Appliquer des mesures de sécurité reconnues pour protéger une application', '00Q8'),
    (68, '1. Analyser le projet de développement de l''application', '00SU'),
    (69, '2. Préparer l''environnement de développement informatique', '00SU'),
    (70, '3. Préparer la base de données', '00SU'),
    (71, '4. Programmer l''interface Web', '00SU'),
    (72, '5. Programmer la logique applicative du côté serveur', '00SU'),
    (73, '6. Programmer la logique applicative du côté client', '00SU'),
    (74, '7. Contrôler la qualité de l''application', '00SU'),
    (75, '8. Participer au déploiement de l''application chez un hébergeur Web', '00SU'),
    (76, '9. Rédiger la documentation', '00SU'),
    (77, '1. Analyser le problème', '00Q2'),
    (78, '2. Traduire l''algorithme dans le langage de programmation', '00Q2'),
    (79, '3. Déboguer le code', '00Q2'),
    (80, '4. Appliquer le plan de tests fonctionnels', '00Q2'),
    (84, '1. Traiter des nombres à représenter dans la mémoire d''un ordinateur', '00Q3'),
    (85, '2. Représentation des figures géométriques en deux dimensions sous la forme d''image numériques', '00Q3'),
    (86, '3. Modélisation des raisonnements logiques à plusieurs variables', '00Q3'),
    (87, '4. Traiter des données quantitatives par les statistiques descriptives', '00Q3'),
    (88, '1. Produire des rapports', '00Q4'),
    (89, '2. Produire des tableaux et des graphiques', '00Q4'),
    (90, '3. Produire des diagrammes ou des plans', '00Q4'),
    (91, '4. Produire des documents de présentation', '00Q4'),
    (92, '5. Partager et synchroniser des documents', '00Q4'),
    (93, '1. Analyser le problème', '00Q6'),
    (94, '2. Modéliser les classes', '00Q6'),
    (95, '3. Produire les algorithmes pour les méthodes', '00Q6'),
    (96, '4. Générer l''interface graphique', '00Q6'),
    (97, '5. Programmer des classes', '00Q6'),
    (98, '6.Documenter la programmation ', '00Q6'),
    (99, '7. Appliquer la procédure liée à la gestion des versions de programmes', '00Q6'),
    (100, '1. Analyser le projet de développement de l''application', '00SW'),
    (101, '2. Préparer l''environnement de développement informatique', '00SW'),
    (102, '3. Générer des représentations de mondes réels ou imaginaires', '00SW'),
    (103, '4. Programmer la logique du jeu ou de la simulation', '00SW'),
    (104, '5. Contrôler la qualité de l''application', '00SW'),
    (105, '6. Participer à la mise en service de l''application', '00SW'),
    (106, '7. Rédiger la documentation', '00SW'),
    (107, '1. Analyser le projet de développement de l''application', '00SV'),
    (108, '2. Préparer l''environnement de développement informatique', '00SV'),
    (109, '3. Préparer la base de données', '00SV'),
    (110, '4. Programmer la logique applicative du service', '00SV'),
    (111, '5. Programmer une application de test utilisant le service', '00SV'),
    (112, '6. Contrôler la qualité du service', '00SV'),
    (113, '7. Participer au déploiement du service', '00SV'),
    (114, '8. Rédiger la documentation', '00SV'),
    (115, '1. Analyser le projet de développement de l''application', '00SS'),
    (116, '2. Préparer l''environnement de développement informatique', '00SS'),
    (117, '3. Préparer la ou les base de données', '00SS'),
    (118, '4. Générer ou programmer l''interface graphique', '00SS'),
    (119, '5. Programmer la logique applicative', '00SS'),
    (120, '6. Contrôler la qualité de l''application', '00SS'),
    (121, '7. Participer à la mise en service de l''application', '00SS'),
    (122, '8. Rédiger la documentation', '00SS'),
    (123, '1. Analyser le projet de développement de l''application', '00SX'),
    (124, '2. Préparer l''environnement de développement informatique et le banc d''essai', '00SX'),
    (125, '3. Générer ou programmer l''interface utilisateur', '00SX'),
    (126, '4. Programmer la logique applicative de l''objet et la logique applicative de contrôle ou de surveillance', '00SX'),
    (127, '5. Contrôler la qualité de l''application', '00SX'),
    (128, '6. Participer à la mise en service de l''application', '00SX'),
    (129, '7. Rédiger la documentation', '00SX');

    INSERT INTO RealisationContext (id, description) VALUES
    (1, 'À l''aide d''algoritmes de base'),
    (2, 'À partir de situations problèmes'),
    (3, 'À l''aide de données quantitatives'),
    (4, 'À l''aide des normes de présentation'),
    (5, 'À l''aide de documentation et d''outils de recherche'),
    (6, 'Pour un système de gestion de base de données relationnel ou autre'),
    (7, 'À partir d''un modèle de données et des spécifications du système de gestion de base de données'),
    (8, 'À l''aide de sources d''information'),
    (9, 'À partir du cahier des charges fonctionnel et de diagrammes d''architecture'),
    (10, 'À l''aide de la documentation technique'),
    (11, 'Pour différents systèmes d''exploitation'),
    (12, 'À partir d''une demande'),
    (13, 'À l''aide d''ordinateurs, de périphériques, de composants internes amovibles, etc.'),
    (14, 'À l''aide de la documentation technique'),
    (15, 'À l''aide de systèmes d''exploitation, d''applications, d''utilitaires, de pilotes, de modules d''extensions, etc.'),
    (16, 'Pour différentes plateformes cibles : tablettes, téléphones intelligents, ordinateurs de bureau, etc.'),
    (17, 'Pour de nouvelles applications et des applications à modifier'),
    (18, 'À partir des documents de conception'),
    (19, 'À l''aide d''un compilateur conçu pour la plateforme cible, d''un compilateur croisé ou d''un interpréteur'),
    (20, 'À l''aide d''un émulateur sur la plateforme hôte'),
    (21, 'À l''aide de procédures de suivi des problèmes et de gestion des versions'),
    (22, 'Pour des formes d''organisation du travail variées'),
    (23, 'À l''aide de normes, de méthodes et de bonnes pratiques en matière de développement d''applications et de gestion de réseaux'),
    (24, 'À l''aide de lois, de code d''éthique et de politique d''entreprise'),
    (25, 'À partir d''un incident, d''un problème ou d''une demande'),
    (26, 'À l''aide de documentation et d''une base de connaissances'),
    (27, 'À l''aide de normes de présentation'),
    (28, 'À partir d''une demande et d''exigences de la cliente ou du client'),
    (29, 'À l''aide de normes, de méthodes et de bonnes pratiques en matière de développement d''applications'),
    (30, 'À l''aide de sources d''information'),
    (31, 'À l''aide d''applications et d''équipement informatique'),
    (32, 'Pour des réseaux informatiques locaux filaires et sans fil'),
    (33, 'À partir d''une demande'),
    (34, 'À l''aide d''ordinateurs, de dispositifs, d''interconnexion et de câblage'),
    (35, 'À l''aide de la documentation technique'),
    (36, 'À l''aide de mesures de sécurité reconnues'),
    (37, 'À l''aide de logiciels de sécurité informatique et de bibliothèques de cryptographie'),
    (38, 'Pour des applications Web transactionnelles : réservations, inscriptions, travail collaboratif, gestion des stocks, commerce électronique, etc.'),
    (39, 'Pour de nouvelles applications et des applications à modifier'),
    (40, 'À partir des documents de conception'),
    (41, 'À l''aide d''images'),
    (42, 'À l''aide de procédures de suivi des problèmes et de gestion des versions'),
    (43, 'Pour des problèmes dont la solution est simple'),
    (44, 'À l''aide d''algorithmes de base'),
    (45, 'À l''aide d''un débogueur et d''un plan de tests fonctionnels'),
    (46, 'À l''aide de logiciels de traitement de texte, de tableurs ainsi que de logiciels de dessin, de présentation et de travail collaboratif'),
    (47, 'À l''aide d''images, de sons et de vidéos'),
    (48, 'À l''aide de normes de présentation'),
    (49, 'À partir de situations problématiques'),
    (50, 'À l''aide de données quantitatives'),
    (51, 'À l''aide de logiciels de traitement de texte, de tableurs ainsi que de logiciels de dessin, de présentation et de travail collaboratif'),
    (52, 'À partir d''un problème'),
    (53, 'À l''aide de règles de nomenclature et de codage'),
    (54, 'Pour différents jeux ou simulations : jeux d''action, jeux de rôles, simulations de vol, simulateurs de procédés industriels, etc.'),
    (55, 'Pour de nouvelles applications et des applications à modifier'),
    (56, 'À partir de documents de conception'),
    (57, 'À l''aide d''un moteur de jeu ou de simulation'),
    (58, 'À l''aide de sons et d''images 2D et 3D'),
    (59, 'À l''aide de procédures de suivi des problèmes et de gestion des versions'),
    (60, 'Pour des services d''échange de données alimentant des applications natives, Web ou des objets connectés'),
    (61, 'Pour de nouvelles applications et des applications à modifier'),
    (62, 'À partir des documents de conception'),
    (63, 'À l''aide de procédures de suivi des problèmes et de gestion des versions'),
    (64, 'Pour différentes plateformes cibles : tablettes, téléphones intelligents, ordinateur de bureau, etc.'),
    (65, 'Pour de nouvelles applications et des applications à modifier'),
    (66, 'À partir des documents de conception'),
    (67, 'À l''aide d''un compilateur conçu pour la plateforme cible, d''un compilateur croisé ou d''un interpréteur'),
    (68, 'À l''aide d''un émulateur sur la plateforme hôte'),
    (69, 'À l''aide d''images'),
    (70, 'À l''aide de procédures de suivi des problèmes et de gestion des versions'),
    (71, 'Pour des applications associées à des dispositifs mobiles prêts-à-porter, à la domotique, à l''immotique, à la robotique, à la surveillance de procédés, etc.'),
    (72, 'Pour de nouvelles applications et des applications à modifier'),
    (73, 'À partir des documents de conception'),
    (74, 'À l''aide de procédures de suivi des problèmes et de gestion des versions');

    INSERT INTO CompetencyContext (contextId, competencyCode) VALUES
    (5, '0000'),
    (11, '00Q1'),
    (12, '00Q1'),
    (13, '00Q1'),
    (14, '00Q1'),
    (15, '00Q1'),
    (43, '00Q2'),
    (44, '00Q2'),
    (45, '00Q2'),
    (49, '00Q3'),
    (50, '00Q3'),
    (51, '00Q4'),
    (32, '00Q5'),
    (33, '00Q5'),
    (34, '00Q5'),
    (35, '00Q5'),
    (52, '00Q6'),
    (53, '00Q6'),
    (6, '00Q7'),
    (7, '00Q7'),
    (36, '00Q8'),
    (37, '00Q8'),
    (22, '00SE'),
    (23, '00SE'),
    (24, '00SE'),
    (8, '00SF'),
    (9, '00SF'),
    (10, '00SF'),
    (25, '00SG'),
    (26, '00SG'),
    (27, '00SG'),
    (30, '00SH'),
    (31, '00SH'),
    (16, '00SR'),
    (17, '00SR'),
    (18, '00SR'),
    (19, '00SR'),
    (20, '00SR'),
    (21, '00SR'),
    (64, '00SS'),
    (65, '00SS'),
    (66, '00SS'),
    (67, '00SS'),
    (68, '00SS'),
    (69, '00SS'),
    (70, '00SS'),
    (38, '00SU'),
    (39, '00SU'),
    (40, '00SU'),
    (41, '00SU'),
    (42, '00SU'),
    (60, '00SV'),
    (61, '00SV'),
    (62, '00SV'),
    (63, '00SV'),
    (54, '00SW'),
    (55, '00SW'),
    (56, '00SW'),
    (57, '00SW'),
    (58, '00SW'),
    (59, '00SW'),
    (71, '00SX'),
    (72, '00SX'),
    (73, '00SX'),
    (74, '00SX'),
    (28, '00SY'),
    (29, '00SY');

    INSERT INTO PerformanceCriterion (id, description) VALUES
    (1, 'Décomposition correcte du problème'),
    (2, 'Découpage efficace du code informatique'),
    (3, 'Représentation correcte de nombres dans différentes bases'),
    (4, 'Saisie correcte de l''information'),
    (5, 'Personnalisation adéquate de l''interface du tableur électronique'),
    (6, 'Choix approprié des sources d''information'),
    (7, 'Fiabilité et diversité de l''information recueillie'),
    (8, 'Utilisation appropriée des outils de recherche'),
    (9, 'Distinction juste des principales caractéristiques des domaines du développement des applications et de l''administration des réseaux informatiques'),
    (10, 'Distinction juste des caractéristiques des produits et des services offerts par les entreprises et les établissements'),
    (11, 'Distinction juste des différentes professions'),
    (12, 'Reconnaissance adéquate des associations professionnelles et syndicales présentes'),
    (13, 'Reconnaissance adéquate des sources et des niveaux de risque pour la santé et la sécurité au travail'),
    (14, 'Examen détaillé des tâches et des responsabilités liées à la profession'),
    (15, 'Distinction juste des connaissances, des comportements, des attitudes et des habiletés nécessaires à l''exercice de la profession'),
    (16, 'Distinction juste des limites d''intervention propres à la profession'),
    (19, 'Décomposition correcte du problème'),
    (20, 'Détermination correcte des données d''entrée, des données de sortie et de la nature des traitements'),
    (21, 'Choix et adaptation appropriés de l''algorithme'),
    (22, 'Choix approprié des instructions et des types de données élémentaires'),
    (23, 'Découpage efficace du code informatique'),
    (24, 'Organisation logique des instructions'),
    (25, 'Respect de la syntaxe du langage'),
    (26, 'Code informatique conforme à l''algorithme'),
    (27, 'Utilisation efficace du débogeur'),
    (28, 'Repérage complet des erreurs'),
    (29, 'Détermination judicieuse de stratégies de correction des erreurs'),
    (30, 'Pertinence des correctifs'),
    (31, 'Notation claire des solutions aux problèmes rencontrés'),
    (32, 'Manifestation d''attitudes et de comportements empreints de rigeur'),
    (33, 'Repérage complet des erreurs de fonctionnement'),
    (34, 'Pertinence des correctifs'),
    (35, 'Fonctionnement correct du programme'),
    (36, 'Notation claire de l''information relative aux tests et à leurs résultats'),
    (37, 'Représentation correcte de nombres dans différentes bases'),
    (38, 'Conversion correcte de nombres d''une base à une autre'),
    (39, 'Interprétation juste des limites des types de représentation des nombres'),
    (40, 'Interprétation juste de la précision des types de représentation des nombres'),
    (41, 'Choix approprié du type de représentation des nombres'),
    (42, 'Détermination correcte de la taille, de la dimension et de la résolution de l''image'),
    (43, 'Représentation correcte de points et de droites'),
    (44, 'Application correcte des équations de translation, de rotation et d''homothétie'),
    (45, 'Concordance des figures géométriques avec leur représentation dans l''image'),
    (46, 'Formulation correcte des fonctions logiques'),
    (47, 'Simplification efficace des fonctions logiques'),
    (48, 'Utilisation appropriée de l''algèbre de Boole'),
    (49, 'Production exacte de tables de vérité'),
    (50, 'Vérification appropriée des fonctions logiques'),
    (51, 'Calcul exact de la moyenne, de la médiane, de la variance et de l''écart type'),
    (52, 'Clarté et exactitude des représentations graphiques des données'),
    (53, 'Analyse juste des résultats'),
    (54, 'Personnalisation correcte de l''interface du traitement de texte'),
    (55, 'Saisie correcte de l''information'),
    (56, 'Intégration correcte d''images'),
    (57, 'Utilisation et modification appropriées des styles et des modèles'),
    (58, 'Insertion correcte d''une table des matières automatique'),
    (59, 'Utilisation efficace du correcteur'),
    (60, 'Respect des normes de présentation'),
    (61, 'Personnalisation adéquate et l''interface du tableur électronique'),
    (62, 'Choix approprié du type de tableau et de graphique à produire'),
    (63, 'Choix et utilisation appropriés des fonctions de recherche, de logique et de calcul'),
    (64, 'Élaboration de formules mathématiques appropriées'),
    (65, 'Respect des normes de présentation'),
    (66, 'Personnalisation correcte de l''interface du logiciel de dessin'),
    (67, 'Choix de l''échelle et du format en fonction des exigences de représentation'),
    (68, 'Rédaction correcte et claire des annotations et du cartouche'),
    (69, 'Respect des normes de présentation'),
    (70, 'Décomposition du problème en fonction des exigences de l''approche orientée objet'),
    (71, 'Détermination correcte des données d''entrée, des données de sortie et de la nature des traitements'),
    (72, 'Détermination juste des classes à modéliser'),
    (73, 'Détermination correcte des algorithmes à produire'),
    (74, 'Détermination correcte des attributs et des méthodes des classes'),
    (75, 'Application judicieuse des principes d''encapsulaion et d''héritage'),
    (76, 'Représentation graphique correcte des classes et de leurs relations'),
    (77, 'Respect des règles de nomenclature'),
    (78, 'Détermination adéquate des opérations nécessaires pour chaque méthode'),
    (79, 'Détermination correcte d''une séquence logique des opérations'),
    (80, 'Vérification appropriée du fonctionnement des algorithmes'),
    (81, 'Représentation correcte des algorithmes'),
    (82, 'Choix approprié des éléments graphiques pour l''affichage et la saisie'),
    (83, 'Positionnement correct des éléments graphiques'),
    (84, 'Paramétrage correct des éléments graphiques'),
    (85, 'Choix approprié des instructions, des types de données élémentaires et des structures de données'),
    (86, 'Organisation logique des instructions'),
    (87, 'Programmation correcte des messages à afficher à l''utilisatrice ou à l''utilisateur'),
    (88, 'Intégration correcte des classes dans le programme'),
    (89, 'Fonctionnement correct du programme'),
    (90, 'Respect de la syntaxe du langage'),
    (91, 'Respect des règles de codage'),
    (92, 'Analyse juste du modèle de données'),
    (93, 'Analyse juste des spécifications du système de gestion de base de données'),
    (94, 'Formulation appropriée des instructions de création de la base de données'),
    (95, 'Détermination judicieuse des types de requêtes à formuler'),
    (96, 'Utilisation appropriée des clauses, des opérations, des commandes ou des paramètres'),
    (97, 'Utilisation appropriée des expressions régulières'),
    (98, 'Fonctionnellement correct des requêtes'),
    (99, 'Détermination judicieuse des techniques à utiliser'),
    (100, 'Gestion correcte des autorisations'),
    (101, 'Cryptage approprié des données'),
    (102, 'Utilisation appropriée des contraintes d''intégrité référentielle, des déclencheurs ou des transactions'),
    (103, 'Détermination judicieuse des traitements de données à automatiser'),
    (104, 'Création appropriée de procédures stockées ou de scripts'),
    (105, 'Notation claire de la documentation d''aide à la programmation'),
    (106, 'Choix judicieux des techniques de sauvegarde et de restauration à utiliser'),
    (107, 'Utilisation appropriée de techniques de sauvegarde et de restauration de la base de données'),
    (108, 'Respect de la procédure et de la fréquence de sauvegarde'),
    (109, 'Analyse juste du cahier des charges fonctionnel'),
    (110, 'Analyse juste de l''architecture logicielle et de l''architecture réseau informatique'),
    (111, 'Relevé complet des exigences techniques du projet'),
    (112, 'Choix approprié des sources d''information'),
    (113, 'Inventaire précis des composants logiciels et matériels disponibles'),
    (114, 'Analyse juste des caractéristiques des plateformes, des applications et des outils de développement'),
    (115, 'Analyse juste des caractéristiques des ordinateurs, des dispositifs d''interconnexion et des périphériques '),
    (116, 'Analyse juste des caractéristiques des protocoles de communication filaires et sans fil'),
    (117, 'Pertinence des avis sur la compatibilité des composants'),
    (118, 'Pertinence des avis sur la longévité, la stabilité, l''efficacité et la maintenabilité des composants'),
    (119, 'Interprétation juste de la demande'),
    (120, 'Interprétation juste des spécifications de l''équipement informatique'),
    (121, 'Ajout correct de composants amovibles'),
    (122, 'Raccordement correct des périphériques'),
    (123, 'Positionnement ergonomique de l''ordinateur et de ses périphériques'),
    (124, 'Utilisation appropriée des utilitaires de préparation des systèmes de fichiers'),
    (125, 'Application correcte de la procédure d''installation du système d''exploitation et des pilotes'),
    (126, 'Configuration correcte du système d''exploitation et des pilotes'),
    (127, 'Personnalisation du système d''exploitation en fonction des besoins des utilisatrices et des utilisateurs'),
    (128, 'Application correcte de la procédure d''installation des applications et des modules d''extension'),
    (129, 'Configuration correcte des applications et des modules d''extension'),
    (130, 'Personnalisation des applications en fonction des besoins des utilisatrices et utilisateurs'),
    (131, 'Fonctionnement correcte des applications'),
    (132, 'Organisation fonctionnelle de la structure des fichiers et des répertoires'),
    (133, 'Utilisation appropriée des utilitaires d''archivage et de compression'),
    (134, 'Création correcte des comptes et des groupes d''utilisateurs'),
    (135, 'Attribution correcte des droits d''accès'),
    (136, 'Gestion appropriée des processus, de la mémoire et de l''espace disque'),
    (137, 'Rédaction correcte de scripts'),
    (138, 'Analyse juste des documents de conception'),
    (139, 'Détermination correcte des tâches à effectuer'),
    (140, 'Installation correcte des logiciels et des bibliothèques sur la plateforme hôte'),
    (141, 'Configuration appropriée de la plateforme cible'),
    (142, 'Configuration appropriée du système de gestion de versions'),
    (143, 'Importation correcte du code source'),
    (144, 'Choix et utilisation appropriée des éléments graphiques pour l''affichage et la saisie'),
    (145, 'Intégration correcte des images'),
    (146, 'Adaptation de l''interface en fonction du format d''affichage et de la résolution'),
    (147, 'Programmation correcte des interactions entre l''interface graphique et l''utilisatrice ou l''utilisateur'),
    (148, 'Programmation correcte des communications avec les périphériques et les fonctions logicielles de la plateforme cible'),
    (149, 'Utilisation judicieuse des fils d''exécution'),
    (150, 'Intégration précise des sons et des vidéos'),
    (151, 'Application correcte des techniques d''internationalisation'),
    (152, 'Application rigoureuse des techniques de programmation sécurisée'),
    (153, 'Application rigoureuse des plans de tests sur l''émulateur et sur la plateforme cible'),
    (154, 'Revue de code et de sécurité rigoureuse'),
    (155, 'Pertinence des correctifs'),
    (156, 'Respect des procédures de suivi des problèmes et de gestion des versions'),
    (157, 'Respect des documents de conception'),
    (158, 'Préparation appropriée de l''application en vue de son déploiement ou de son installation'),
    (159, 'Déploiement ou installation corrects de l''application'),
    (160, 'Détermination correcte de l''information à rédiger'),
    (161, 'Notation claire du travail effectué'),
    (162, 'Manifestation d''attitudes et de comportements démontrant une capacité d''écoute'),
    (163, 'Adaptation du niveau de langage selon la situation'),
    (164, 'Respect des règles de politesse et de courtoisie'),
    (165, 'Respect de l''approche client'),
    (166, 'Manifestation d''attitudes et de comportements de respect, d''ouverture d''esprit et de collaboration'),
    (167, 'Communication efficace avec les membres de l''équipe'),
    (168, 'Exécution correcte des tâches confiées'),
    (169, 'Respect des règles de fonctionnement en équipe'),
    (170, 'Respect de la culture d''entreprise'),
    (171, 'Respect des normes, des méthodes ou des bonnes pratiques en matière de développement d''applications et de gestion de réseaux'),
    (172, 'Respect des limites d''intervention professionnelle et de l''expertise des membres d''autres professions'),
    (173, 'Respect des échéanciers'),
    (174, 'Distinction juste des principaux délits et des principaux actes criminels dans le domaine informatique'),
    (175, 'Distinction juste des principales atteintes à la propriété intellectuelle dans le domaine informatique'),
    (176, 'Appréciation juste des conséquences des délits, des actes criminels et des atteintes à la propriété intellectuelle'),
    (177, 'Détermination des mesures appropriées selon la situation'),
    (178, 'Respect des lois, des codes éthiques et des politiques d''entreprise'),
    (179, 'Analyse juste de l''incident, du problème ou de la demande'),
    (180, 'Consultation appropriée de la base de connaissances'),
    (181, 'Détermination judicieuse du niveau de priorité'),
    (182, 'Choix approprié de l''intervention à effectuer ou transmission de l''information à la personne ou au service concerné'),
    (183, 'Respect des limites d''intervention professionnelle'),
    (184, 'Manifestation d''attitudes et de comportements favorisant l''établissement d''une relation de confiance'),
    (185, 'Relevé des actions significatives posées par les utilisatrices ou les utilisateurs'),
    (186, 'Pertinence des conseils'),
    (187, 'Pertinence et efficacité des démonstrations'),
    (188, 'Utilisation d''un niveau de langage approprié'),
    (189, 'Manifestation d''attitudes et de comportements emprunts de patience'),
    (190, 'Analyse juste de la documentation existante'),
    (191, 'Détermination judicieuse du niveau de connaissance des utilisatrices ou les utilisateurs'),
    (192, 'Production de documents conformes aux besoins des utilisatrices et utilisateurs'),
    (193, 'Utilisation du vocabulaire approprié'),
    (194, 'Respect des normes de documentation'),
    (195, 'Respect des règles orthographiques et grammaticales'),
    (196, 'Vérification appropriée de la satisfaction de l''utilisatrice et de l''utilisateur'),
    (197, 'Détermination correcte du degré d''adéquation entre l''intervention et le besoin'),
    (198, 'Formulation claire de recommandations visant à prévenir la récurrence de pannes'),
    (199, 'Notation claire de l''intervention dans la base de connaissances'),
    (200, 'Analyse juste de la demande et des exigences de la cliente ou du client'),
    (201, 'Analyse juste des caractéristiques de l''équipement informatique et des applications utilisés par la cliente ou le client'),
    (202, 'Pertinence des avis sur la nature des besoins'),
    (203, 'Pertinence des avis sur les normes, les méthodes et les bonnes pratiques à utiliser en matière de développement d''applicationss'),
    (204, 'Pertinence dans avis sur le choix de l''architecture logicielle'),
    (205, 'Évaluation juste des composants logiciels et matériels à utiliser'),
    (206, 'Pertinence des avis sur les mesures de sécurité à mettre en place'),
    (207, 'Pertinence des avis sur les stratégies de tests à utiliser'),
    (208, 'Pertinence des avis sur la fiabilité de la solution informatique'),
    (209, 'Modélisation d''une base de données conforme au besoin'),
    (210, 'Détermination claire des données initiales d''une base de données'),
    (211, 'Description claire de la logique applicative et de l''interface à générer ou à programmer'),
    (212, 'Modélisation orienté objet conforme aux principes d''encapsulation, d''héritage, de compositions ou de polymorphisme'),
    (213, 'Choix ou production judicieux des algorithmes'),
    (214, 'Respect des règles de nomenclature'),
    (215, 'Représentation graphique correcte des différents modèles'),
    (216, 'Rédaction correcte des plans de tests unitaires, d''intégration, fonctionnels ou d''acception'),
    (217, 'Participation active à la revue de conception'),
    (218, 'Utilisation du vocabulaire approprié'),
    (219, 'Respect des normes, des méthodes et des bonnes pratiques en matières de développement d''applications'),
    (220, 'Recherche efficace de sources d''information'),
    (221, 'Utilisation appropriée des outils de veille'),
    (222, 'Analyse juste de l''information recueillie'),
    (223, 'Détermination judicieuse des technologies à expérimenter'),
    (224, 'Raccordement correct de l''équipement'),
    (225, 'Installation correcte des applications ou des outils de développement nécessaires'),
    (226, 'Mise à l''essai adéquate de la technologie'),
    (227, 'Manifestation d''attitudes et de comportements démontrant l''autonomie et l''ouverture d''esprit'),
    (228, 'Participation active aux discussions'),
    (229, 'Justification adéquate du potentiel de la technologie'),
    (230, 'Interprétation juste de la demande'),
    (231, 'Détermination correcte des services à installer'),
    (232, 'Choix approprié des dispositifs d''interconnexion à installer'),
    (233, 'Diagramme d''architecture du réseau informatique local conforme au besoin'),
    (234, 'Positionnement et raccordement corrects des dispositifs d''interconnxion'),
    (235, 'Configuration correcte des dispositifs d''interconnexion'),
    (236, 'Notation claire des configurations effectuées'),
    (237, 'Raccordement des ordinateurs au réseau'),
    (238, 'Configuration correcte de l''accès au réseau'),
    (239, 'Notation claire des configurations effectuées'),
    (240, 'Application rigoureuse de la procédure d''installation des services'),
    (241, 'Configuration correcte des services'),
    (242, 'Notation claire des configurations effectuées'),
    (243, 'Application rigoureuse des plans de tests'),
    (244, 'Pertinence des correctifs'),
    (245, 'Fonctionnement optimal du réseau'),
    (246, 'Inventaire précis de l''équipement informatique et des applications installés'),
    (247, 'Inventaire adéquat des menaces potentielles et des vulnérabilités'),
    (248, 'Détermination correcte des conséquences sur la sécurité'),
    (249, 'Choix appropriée des mesures de sécurité à appliquer'),
    (250, 'Utilisation appropriée des stratégies de sauvegarde'),
    (251, 'Utilisation appropriée des stratégies d''attribution des droits d''accès'),
    (252, 'Configuration et personnalisation correctes des logiciels antivirus et coupe-feu'),
    (253, 'Utilisation appropriée des utilitaires cryptographie'),
    (254, 'Utilisation appropriée des stratégies de sécurisation des données entrées par l''utilisatrice et l''utilisateur'),
    (255, 'Utilisation appropriée des techniques de contrôle des erreurs et des exceptions'),
    (256, 'Utilisation appropriée de mécanismes d''authentification et d''autorisation sécuritaires'),
    (257, 'Utilisation appropriée des bibliothèques de cryptographie'),
    (258, 'Analyse juste des documents de conception'),
    (259, 'Détermination correcte des tâches à effectuer'),
    (260, 'Installation correcte de la plateforme de développement Web et du système de gestion de base de données de développement'),
    (261, 'Installation correcte des logiciels et des bibliothèques'),
    (262, 'Configuration appropriée du système de gestion de versions'),
    (263, 'Importation correcte du code source'),
    (264, 'Création ou adaptation correctes de la base de données'),
    (265, 'Insertion correcte des données initiales ou des données de tests'),
    (266, 'Respect du modèle de données'),
    (267, 'Utilisation appropriée du langage de balisage'),
    (268, 'Création et utilisation appropriées des feuilles de styles'),
    (269, 'Intégration correcte des images'),
    (270, 'Création appropriée des formulaires Web'),
    (271, 'Adaptation de l''interface en fonction du format d''affichage et de la résolution'),
    (272, 'Programmation ou intégration correctes de mécanismes d''authentification et d''autorisation'),
    (273, 'Programmation correcte des interactions entre l''interface Web et l''utilisatrice ou l''utilisateur'),
    (274, 'Choix approprié des clauses, des opérateurs, des commandes ou des paramètres dans les requêtes à la base de données'),
    (275, 'Manipulation correcte des données de la base de données'),
    (276, 'Utilisation appropriée des services d''échange de données'),
    (277, 'Application correcte des techniques d''internationalisation'),
    (278, 'Application rigoureuse des techniques de programmation sécurisée'),
    (279, 'Manipulation adéquate des objets du modèle DOM'),
    (280, 'Programmation appropriée d''appels asynchrones'),
    (281, 'Programmation correcte des interactions entre l''interface Web et l''utilisatrice ou l''utilisateur'),
    (282, 'Utilisation systématique des techniques de validation de données des formulaires Web'),
    (283, 'Formulaires Web conformes aux exigences d''utilisabilité'),
    (284, 'Application rigoureuse des plans de tests'),
    (285, 'Revues de code et de sécurité rigoureuses'),
    (286, 'Pertinence des correctifs'),
    (287, 'Respect des procédures de suivi des problèmes et de gestion des versions'),
    (288, 'Respect des documents de conception'),
    (289, 'Détermination judicieuse du nom de domaine'),
    (290, 'Configuration appropriée de l''application chez l''hébergeur Web'),
    (291, 'Application correcte de la procédure de migration de l''application chez l''hébergeur Web'),
    (292, 'Application rigoureuse des mesures de sécurité'),
    (293, 'Respect des exigences de référencement'),
    (294, 'Détermination correcte de l''information à rédiger'),
    (295, 'Notation claire du travail effectué'),
    (296, 'Décomposition correcte du problème'),
    (297, 'Détermination correcte des données d''entrée, des données de sortie et de la nature des traitements'),
    (298, 'Choix et adaptation appropriés de l''algorithme'),
    (299, 'Choix approprié des instructions et des types de données élémentaires'),
    (300, 'Découpage efficace du code informatique'),
    (301, 'Organisation logique des instructions'),
    (302, 'Respect de la syntaxe du langage'),
    (303, 'Code informatique conforme à l''algorithme'),
    (304, 'Utilisation efficace du débogeur'),
    (305, 'Repérage complet des erreurs'),
    (306, 'Détermination judicieuse de stratégies de correction des erreurs'),
    (307, 'Pertinence des correctifs'),
    (308, 'Notation claire des solutions aux problèmes rencontrés'),
    (309, 'Manifestation d''attitudes et de comportements empreints de rigeur'),
    (310, 'Repérage complet des erreurs de fonctionnement'),
    (311, 'Pertinence des correctifs'),
    (312, 'Fonctionnement correct du programme'),
    (313, 'Notation claire de l''information relative aux tests et à leurs résultats'),
    (314, 'Personnalisation correcte de l''interface du traitement de texte'),
    (315, 'Saisie correcte de l''information'),
    (316, 'Intégration correcte d''images'),
    (317, 'Utilisation et modification appropriées des styles et des modèles'),
    (318, 'Insertion correcte d''une table des matières automatique'),
    (319, 'Utilisation efficace du correcteur'),
    (320, 'Respect des normes de présentation'),
    (321, 'Personnalisation adéquate et l''interface du tableur électronique'),
    (322, 'Choix approprié du type de tableau et de graphique à produire'),
    (323, 'Choix et utilisation appropriés des fonctions de recherche, de logique et de calcul'),
    (324, 'Élaboration de formules mathématiques appropriées'),
    (325, 'Respect des normes de présentation'),
    (326, 'Personnalisation correcte de l''interface du logiciel de présentation'),
    (327, 'Choix approprié de la résolution et du format d''affichage'),
    (328, 'Intégration adéquate d''images, de sons et de vidéos'),
    (329, 'Lisibilité des présentations'),
    (330, 'Respect des règles orthographiques et grammaticales'),
    (331, 'Respect des normes de présentation'),
    (332, 'Personnalisation correcte de l''interface du logiciel de dessin'),
    (333, 'Choix de l''échelle et du format en fonction des exigences de représentation'),
    (334, 'Rédaction correcte et claire des annotations et du cartouche'),
    (335, 'Respect des normes de présentation'),
    (336, 'Personnalisation correcte de l''interface du logiciel de travail collaboratif'),
    (337, 'Conversion appropriée des formats de fichiers'),
    (338, 'Classification adéquate des documents'),
    (339, 'Attribution correcte des accès aux documents partagés'),
    (340, 'Gestion efficace des conflits de versions'),
    (341, 'Représentation correcte de nombres dans différentes bases'),
    (342, 'Conversion correcte de nombres d''une base à une autre'),
    (343, 'Interprétation juste des limites des types de représentation des nombres'),
    (344, 'Interprétation juste de la précision des types de représentation des nombres'),
    (345, 'Choix approprié du type de représentation des nombres'),
    (346, 'Détermination correcte de la taille, de la dimension et de la résolution de l''image'),
    (347, 'Représentation correcte de points et de droites'),
    (348, 'Application correcte des équations de translation, de rotation et d''homothétie'),
    (349, 'Concordance des figures géométriques avec leur représentation dans l''image'),
    (350, 'Formulation correcte des fonctions logiques'),
    (351, 'Simplification efficace des fonctions logiques'),
    (352, 'Utilisation appropriée de l''algèbre de Boole'),
    (353, 'Production exacte de tables de vérité'),
    (354, 'Vérification appropriée des fonctions logiques'),
    (355, 'Calcul exact de la moyenne, de la médiane, de la variance et de l''écart type'),
    (356, 'Clarté et exactitude des représentations graphiques des données'),
    (357, 'Analyse juste des résultats'),
    (358, 'Personnalisation correcte de l''interface du traitement de texte'),
    (359, 'Saisie correcte de l''information'),
    (360, 'Intégration correcte d''images'),
    (361, 'Utilisation et modification appropriées des styles et des modèles'),
    (362, 'Insertion correcte d''une table des matières automatique'),
    (363, 'Utilisation efficace du correcteur'),
    (364, 'Respect des normes de présentation'),
    (365, 'Personnalisation adéquate de l''interface du tableur électronique'),
    (366, 'Choix approprié du type de tableau et de graphiques à produire'),
    (367, 'Choix et utilisation appropriés des fonctions de recherche, de logique et de calcul'),
    (368, 'Élaboration de formules mathématiques appropriées'),
    (369, 'Respect des normes de présentation'),
    (370, 'Personnalisation correcte de l''interface du logiciel de dessin'),
    (371, 'Choix de l''échelle et du format en fonction des exigences de représentation'),
    (372, 'Représentation correcte d''éléments géométriques'),
    (373, 'Utilisation d''une banque de symboles en fonction des exigences de représentation'),
    (374, 'Rédaction correcte et claire des annotations et du cartouche'),
    (375, 'Respect des normes de présentation'),
    (376, 'Personnalisation adéquate et l''interface du tableur électronique'),
    (377, 'Choix approprié du type de tableau et de graphique à produire'),
    (378, 'Choix et utilisation appropriés des fonctions de recherche, de logique et de calcul'),
    (379, 'Élaboration de formules mathématiques appropriées'),
    (380, 'Respect des normes de présentation'),
    (381, 'Personnalisation correcte de l''interface du logiciel de présentation'),
    (382, 'Choix approprié de la résolution et du format d''affichage'),
    (383, 'Intégration adéquate d''images, de sons et de vidéos'),
    (384, 'Lisibilité des présentations'),
    (385, 'Respect des règles orthographiques et grammaticales'),
    (386, 'Respect des normes de présentation'),
    (387, 'Personnalisation correcte de l''interface du logiciel de dessin'),
    (388, 'Choix de l''échelle et du format en fonction des exigences de représentation'),
    (389, 'Rédaction correcte et claire des annotations et du cartouche'),
    (390, 'Respect des normes de présentation'),
    (391, 'Personnalisation correcte de l''interface du logiciel de travail collaboratif'),
    (392, 'Conversion appropriée des formats de fichiers'),
    (393, 'Classification adéquate des documents'),
    (394, 'Attribution correcte des accès aux documents partagés'),
    (395, 'Gestion efficace des conflits de versions'),
    (396, 'Décomposition du problème en fonction des exigences de l''approche orientée objet'),
    (397, 'Détermination correcte des données d''entrée, des données de sortie et de la nature des traitements'),
    (398, 'Détermination juste des classes à modéliser'),
    (399, 'Détermination correcte des algorithmes à produire'),
    (400, 'Détermination correcte des attributs et des méthodes des classes'),
    (401, 'Application judicieuse des principes d''encapsulaion et d''héritage'),
    (402, 'Représentation graphique correcte des classes et de leurs relations'),
    (403, 'Respect des règles de nomenclature'),
    (404, 'Détermination adéquate des opérations nécessaires pour chaque méthode'),
    (405, 'Détermination correcte d''une séquence logique des opérations'),
    (406, 'Vérification appropriée du fonctionnement des algorithmes'),
    (407, 'Représentation correcte des algorithmes'),
    (408, 'Choix approprié des éléments graphiques pour l''affichage et la saisie'),
    (409, 'Positionnement correct des éléments graphiques'),
    (410, 'Paramétrage correct des éléments graphiques'),
    (411, 'Choix approprié des instructions, des types de données élémentaires et des structures de données'),
    (412, 'Organisation logique des instructions'),
    (413, 'Programmation correcte des messages à afficher à l''utilisatrice ou à l''utilisateur'),
    (414, 'Intégration correcte des classes dans le programme'),
    (415, 'Fonctionnement correct du programme'),
    (416, 'Respect de la syntaxe du langage'),
    (417, 'Respect des règles de codage'),
    (418, 'Analyse juste des des documents de conception'),
    (419, 'Détermination correcte des tâches à effectuer'),
    (420, 'Installation correcte des logiciels et des bibliothèques'),
    (421, 'Configurations appropriées du système de gestion de versions'),
    (422, 'Importations correcte du code source'),
    (423, 'Choix et utilisation appropriés des éléments graphiques pour l''affichage et la saisie'),
    (424, 'Intégration correcte des images 2D et 3D'),
    (425, 'Adaptation des représentations en fonction du format d''affichage et de la résolution'),
    (426, 'Programmation correcte des comportements des éléments graphiques et des périphériques'),
    (427, 'Programmation correcte des effets visuels'),
    (428, 'Intégration précise des sons'),
    (429, 'Programmation correcte des interactions'),
    (430, 'Application correcte des techniques d''internationalisation'),
    (431, 'Application rigoureuse des techniques de programmation sécurisée'),
    (432, 'Utilisation appropriée des moteurs de jeu ou de simulation'),
    (433, 'Application rigoureuse des plans de tests'),
    (434, 'Revues de code et de sécurité rigoureuse'),
    (435, 'Pertinence des correctifs'),
    (436, 'Respect des procédures de suivi des problèmes et de gestion des versions'),
    (437, 'Respect des documents de conception'),
    (438, 'Préparation appropriée de l''application en vue de son déploiement, de son exportation ou de son installation'),
    (439, 'Déploiement, exportation ou installation corrects de l''application'),
    (440, 'Détermination correcte de l''information à rédiger'),
    (441, 'Notation claire du travail effectué'),
    (442, 'Analyse juste des documents de conception'),
    (443, 'Détermination correcte des tâches à effectuer'),
    (444, 'Installation correcte de la plateforme de développement et du système de gestion de base de données de développement'),
    (445, 'Installation correcte des logiciels et des bibliothèques'),
    (446, 'Configuration appropriée du système de gestion de versions'),
    (447, 'Importation correcte du code source'),
    (448, 'Création ou adaptation correctes de la base de données'),
    (449, 'Insertion correcte des données initiales ou des données de tests'),
    (450, 'Respect du modèle de données'),
    (451, 'Programmation ou intégration correctes de mécanismes d''authentification, d''autorisation ou d''établissement de liaison sécurisée'),
    (452, 'Programmation correcte de la réception des données d''entrée'),
    (453, 'Choix approprié des clauses, des opérateurs, des commandes ou des paramètres dans les requêtes à la base de données'),
    (454, 'Manipulation correcte des données de la base de données'),
    (455, 'Programmation correcte de l''envoi des données de sortie'),
    (456, 'Application rigoureuse des techniques de programmation sécurisée'),
    (457, 'Respect des protocoles de communication et des formats d''échange de données'),
    (458, 'Récupération exacte de l''interface du service'),
    (459, 'Utilisation appropriée du service'),
    (460, 'Conversion appropriée des données fournies par le service en données exploitables par l''application de test'),
    (461, 'Application rigoureuse des plans de tests'),
    (462, 'Revues de code et de sécurité rigoureuse'),
    (463, 'Pertinence des correctifs'),
    (464, 'Respect des procédures de suivi des problèmes et de gestion des versions'),
    (465, 'Respect des documents de conception'),
    (466, 'Application correcte de la procédure de migration du service sur le serveur'),
    (467, 'Application rigoureuse des mesures de sécurité'),
    (468, 'Détermination correcte de l''information à rédiger'),
    (469, 'Notation claire du travail effectué'),
    (470, 'Analyse juste des documents de conception'),
    (471, 'Détermination correcte des tâches à effectuer'),
    (472, 'Installation correcte des logiciels et des bibliothèques sur la plateforme hôte'),
    (473, 'Configuration appropriée de la plateforme cible'),
    (474, 'Configuration appropriée du système de gestion de versions'),
    (475, 'Importation correcte du code source'),
    (476, 'Création ou adaptation correctes de la base de données locale ou de la base de données distante'),
    (477, 'Insertion correcte des données initiales ou des données de tests'),
    (478, 'Respect du modèle de données'),
    (479, 'Choix et utilisation appropriés des éléments graphiques pour l''affichage et la saisie'),
    (480, 'Intégration correcte des images'),
    (481, 'Adaptation de l''interface en fonction du format d''affichage et de la résolution'),
    (482, 'Programmation ou intégration correctes de mécanismes d''authentification et d''autorisation'),
    (483, 'Programmation correcte des interactions entre l''interface graphique et l''utilisatrice et l''utilisateur'),
    (484, 'Choix approprié des clauses, des opérateurs, des commandes ou des paramètres dans les requêtes à la base de données'),
    (485, 'Manipulation correcte des données de la base de données'),
    (486, 'Programmation correcte de la synchronisation'),
    (487, 'Utilisation appropriée des services d''échange de données'),
    (488, 'Application correcte des techniques de programmation sécurisée'),
    (489, 'Application rigoureuse des plans de tests sur l''émulateur et sur la plateforme cible'),
    (490, 'Revues de code et de sécurité rigoureuse'),
    (491, 'Pertinence des correctifs'),
    (492, 'Respect des procédures de suivi des problèmes et de gestion des versions'),
    (493, 'Respect des documents de conception'),
    (494, 'Préparation appropriée de l''application en vue de son déploiement ou de son installation'),
    (495, 'Déploiement ou installation corrects de l''application'),
    (496, 'Détermination correcte de l''information à rédiger'),
    (497, 'Notation claire du travail effectué'),
    (498, 'Analyse juste des documents de conception'),
    (499, 'Détermination correcte des tâches à effectuer'),
    (500, 'Installation correcte des logiciels et des bibliothèques'),
    (501, 'Position et fixation correctes des objets dans l''environnement de simulation'),
    (502, 'Connexion correcte des objets à l''ordinateur de développement, au réseau ou à d''autres objets'),
    (503, 'Mise à jour correcte des micrologiciels des objets'),
    (504, 'Configuration appropriée du système de gestion de versions'),
    (505, 'Importation correcte du code source'),
    (506, 'Choix et utilisation appropriés des éléments graphiques pour l''affichage et la saisie'),
    (507, 'Intégration correcte des images'),
    (508, 'Adaptation de l''interface en fonction du format d''affichage et de la résolution'),
    (509, 'Programmation correcte des instructions d''acquisition, de traitement et de transmission des données'),
    (510, 'Programmation correcte des interactions entre l''interface et l''utilisatrice et l''utilisateur'),
    (511, 'Utilisation appropriée des services d''échange de données'),
    (512, 'Application correcte des techniques d''internationalisation'),
    (513, 'Application rigoureuse des techniques de programmation sécurisée'),
    (514, 'Transfert correct de l''application sur l''objet connecté'),
    (515, 'Respect des contraintes temporelles'),
    (516, 'Application rigoureuse des plans de tests'),
    (517, 'Revues de code et de sécurité rigoureuses'),
    (518, 'Pertinence des correctifs'),
    (519, 'Respect des procédures de suivi des problèmes et de gestion des versions'),
    (520, 'Respect des documents de conception'),
    (521, 'Préparation appropriée de l''application en vue de son déploiement ou de son installation'),
    (522, 'Déploiement ou installation corrects de l''application'),
    (523, 'Exécution correcte des tests préopérationnels'),
    (524, 'Pertinence de l''information transmise aux utilisatrices ou utilisateurs sur le fonctionnement et la sécurité de l''application'),
    (525, 'Détermination correcte de l''information à rédiger'),
    (526, 'Notation claire du travail effectué');

    INSERT INTO ElementCriterion (elementId, criterionId) VALUES
    (6, 6),
    (6, 7),
    (6, 8),
    (7, 9),
    (7, 10),
    (7, 11),
    (7, 12),
    (7, 13),
    (8, 14),
    (8, 15),
    (8, 16),
    (27, 92),
    (27, 93),
    (27, 94),
    (28, 95),
    (28, 96),
    (28, 97),
    (28, 98),
    (29, 99),
    (29, 100),
    (29, 101),
    (29, 102),
    (30, 103),
    (30, 104),
    (30, 105),
    (31, 106),
    (31, 107),
    (31, 108),
    (32, 109),
    (32, 110),
    (32, 111),
    (33, 112),
    (33, 113),
    (34, 114),
    (34, 115),
    (34, 116),
    (34, 117),
    (34, 118),
    (35, 119),
    (35, 120),
    (35, 121),
    (35, 122),
    (35, 123),
    (36, 124),
    (36, 125),
    (36, 126),
    (36, 127),
    (37, 128),
    (37, 129),
    (37, 130),
    (37, 131),
    (38, 132),
    (38, 133),
    (38, 134),
    (38, 135),
    (38, 136),
    (38, 137),
    (39, 138),
    (39, 139),
    (40, 140),
    (40, 141),
    (40, 142),
    (40, 143),
    (41, 144),
    (41, 145),
    (41, 146),
    (42, 147),
    (42, 148),
    (42, 149),
    (42, 150),
    (42, 151),
    (42, 152),
    (43, 153),
    (43, 154),
    (43, 155),
    (43, 156),
    (43, 157),
    (44, 158),
    (44, 159),
    (45, 160),
    (45, 161),
    (46, 162),
    (46, 163),
    (46, 164),
    (46, 165),
    (47, 166),
    (47, 167),
    (47, 168),
    (47, 169),
    (47, 170),
    (47, 171),
    (47, 172),
    (47, 173),
    (48, 174),
    (48, 175),
    (48, 176),
    (48, 177),
    (48, 178),
    (49, 179),
    (49, 180),
    (49, 181),
    (49, 182),
    (49, 183),
    (50, 184),
    (50, 185),
    (50, 186),
    (50, 187),
    (50, 188),
    (50, 189),
    (51, 190),
    (51, 191),
    (51, 192),
    (51, 193),
    (51, 194),
    (51, 195),
    (52, 196),
    (52, 197),
    (52, 198),
    (52, 199),
    (53, 200),
    (53, 201),
    (53, 202),
    (53, 203),
    (54, 204),
    (54, 205),
    (54, 206),
    (54, 207),
    (54, 208),
    (55, 209),
    (55, 210),
    (55, 211),
    (55, 212),
    (55, 213),
    (55, 214),
    (56, 215),
    (56, 216),
    (56, 217),
    (56, 218),
    (56, 219),
    (57, 220),
    (57, 221),
    (57, 222),
    (57, 223),
    (58, 224),
    (58, 225),
    (58, 226),
    (58, 227),
    (59, 228),
    (59, 229),
    (60, 230),
    (60, 231),
    (60, 232),
    (60, 233),
    (61, 234),
    (61, 235),
    (61, 236),
    (62, 237),
    (62, 238),
    (62, 239),
    (63, 240),
    (63, 241),
    (63, 242),
    (64, 243),
    (64, 244),
    (64, 245),
    (65, 246),
    (65, 247),
    (65, 248),
    (65, 249),
    (66, 250),
    (66, 251),
    (66, 252),
    (66, 253),
    (67, 254),
    (67, 255),
    (67, 256),
    (67, 257),
    (68, 258),
    (68, 259),
    (69, 260),
    (69, 261),
    (69, 262),
    (69, 263),
    (70, 264),
    (70, 265),
    (70, 266),
    (71, 267),
    (71, 268),
    (71, 269),
    (71, 270),
    (71, 271),
    (72, 272),
    (72, 273),
    (72, 274),
    (72, 275),
    (72, 276),
    (72, 277),
    (72, 278),
    (73, 279),
    (73, 280),
    (73, 281),
    (73, 282),
    (73, 283),
    (74, 284),
    (74, 285),
    (74, 286),
    (74, 287),
    (74, 288),
    (75, 289),
    (75, 290),
    (75, 291),
    (75, 292),
    (75, 293),
    (76, 294),
    (76, 295),
    (77, 296),
    (77, 297),
    (77, 298),
    (78, 299),
    (78, 300),
    (78, 301),
    (78, 302),
    (78, 303),
    (79, 304),
    (79, 305),
    (79, 306),
    (79, 307),
    (79, 308),
    (80, 309),
    (80, 310),
    (80, 311),
    (80, 312),
    (80, 313),
    (84, 341),
    (84, 342),
    (84, 343),
    (84, 344),
    (84, 345),
    (85, 346),
    (85, 347),
    (85, 348),
    (85, 349),
    (86, 350),
    (86, 351),
    (86, 352),
    (86, 353),
    (86, 354),
    (87, 355),
    (87, 356),
    (87, 357),
    (88, 358),
    (88, 359),
    (88, 360),
    (88, 361),
    (88, 362),
    (88, 363),
    (88, 364),
    (89, 365),
    (89, 366),
    (89, 367),
    (89, 368),
    (89, 369),
    (90, 370),
    (90, 371),
    (90, 372),
    (90, 373),
    (90, 374),
    (90, 375),
    (91, 376),
    (91, 377),
    (91, 378),
    (91, 379),
    (91, 380),
    (91, 381),
    (91, 382),
    (91, 383),
    (91, 384),
    (91, 385),
    (91, 386),
    (92, 387),
    (92, 388),
    (92, 389),
    (92, 390),
    (92, 391),
    (92, 392),
    (92, 393),
    (92, 394),
    (92, 395),
    (93, 396),
    (93, 397),
    (93, 398),
    (93, 399),
    (94, 400),
    (94, 401),
    (94, 402),
    (94, 403),
    (95, 404),
    (95, 405),
    (95, 406),
    (95, 407),
    (96, 408),
    (96, 409),
    (96, 410),
    (97, 411),
    (97, 412),
    (97, 413),
    (97, 414),
    (97, 415),
    (97, 416),
    (97, 417),
    (100, 418),
    (100, 419),
    (101, 420),
    (101, 421),
    (101, 422),
    (102, 423),
    (102, 424),
    (102, 425),
    (103, 426),
    (103, 427),
    (103, 428),
    (103, 429),
    (103, 430),
    (103, 431),
    (103, 432),
    (104, 433),
    (104, 434),
    (104, 435),
    (104, 436),
    (104, 437),
    (105, 438),
    (105, 439),
    (106, 440),
    (106, 441),
    (107, 442),
    (107, 443),
    (108, 444),
    (108, 445),
    (108, 446),
    (108, 447),
    (109, 448),
    (109, 449),
    (109, 450),
    (110, 451),
    (110, 452),
    (110, 453),
    (110, 454),
    (110, 455),
    (110, 456),
    (110, 457),
    (111, 458),
    (111, 459),
    (111, 460),
    (112, 461),
    (112, 462),
    (112, 463),
    (112, 464),
    (112, 465),
    (113, 466),
    (113, 467),
    (114, 468),
    (114, 469),
    (115, 470),
    (115, 471),
    (116, 472),
    (116, 473),
    (116, 474),
    (116, 475),
    (117, 476),
    (117, 477),
    (117, 478),
    (118, 479),
    (118, 480),
    (118, 481),
    (119, 482),
    (119, 483),
    (119, 484),
    (119, 485),
    (119, 486),
    (119, 487),
    (119, 488),
    (120, 489),
    (120, 490),
    (120, 491),
    (120, 492),
    (120, 493),
    (121, 494),
    (121, 495),
    (122, 496),
    (122, 497),
    (123, 498),
    (123, 499),
    (124, 500),
    (124, 501),
    (124, 502),
    (124, 503),
    (124, 504),
    (124, 505),
    (125, 506),
    (125, 507),
    (125, 508),
    (126, 509),
    (126, 510),
    (126, 511),
    (126, 512),
    (126, 513),
    (126, 514),
    (126, 515),
    (127, 516),
    (127, 517),
    (127, 518),
    (127, 519),
    (127, 520),
    (128, 521),
    (128, 522),
    (128, 523),
    (128, 524),
    (129, 525),
    (129, 526);

    INSERT INTO `ProgramPortal`.`SubmissionHistory` (`id`, `submissionId`, `correctionTime`) VALUES
    (NULL, '1', CURRENT_TIMESTAMP),
    (NULL, '2', CURRENT_TIMESTAMP);

    INSERT INTO `Prior` (courseId, priorId) VALUES
    (2, 1),
    (3, 2);

    INSERT INTO `Notification` (userId, content, isRead) VALUES
    (1,'Ton papa a appelé pour dire allo.', null),
    (1,'Mange tes légumes mon coco', null),
    (1,'Le numéro 2 est corrigé.', null),
    (1,'Coucou petit bonhomme', null);

    INSERT INTO SessionCourse (id, courseId, sessionId) VALUES
    (DEFAULT, 1, 1),
    (DEFAULT, 2, 2),
    (DEFAULT, 3, 1),
    (DEFAULT, 4, 2);

    INSERT INTO TeacherSessionCourse (teacherId, sessionCourseId) VALUES
    (2, 3),
    (2, 1),
    (3, 1);

    INSERT INTO Badge (id, icon, title, description) VALUES
    (DEFAULT, 'fas fa-brain', 'Génie', 'L\'étudiant est un génie de l\'informatique'),
    (DEFAULT, 'fas fa-trophy', 'Trophée', 'L\'étudiant est le plus remarquable'),
    (DEFAULT, 'icon-anchor', 'Robustesse', 'L\'étudiant est assidu dans son travail'),
    (DEFAULT, 'icon-heart', 'Âme Charitable', 'L\'étudiant aide les autres élèves dans leurs travaux'),
    (DEFAULT, 'icon-clock', 'Rapidité du travail', 'L\'étudiant termine les travaux et les exercices avec une rapidité exemplaire');

    INSERT INTO BadgeUser (badgeId, userId, `rank`) VALUES
    (1, 6, 'bronze'),
    (2, 6, 'gold'),
    (1, 7, 'silver');

    INSERT INTO Reward (courseId, title, price, enable) VALUES
    (2, '2% sur la session', 50, true),
    (2, '10% sur le tp1', 25, true),
    (2, '5% sur le TP2', 10, true),
    (2, '50% sur la session', 100, false);

    INSERT INTO File(id, size, path, type, exerciseId, categoryName) VALUES
    (NULL, 3105, '/media/sf_www/portail-programme/app/../data/teacher/test.java', 'java', 1, 'file'),
    (NULL, 3105, '/media/sf_www/portail-programme/app/../data/teacher/test.java', 'file', 1, 'file'),
    (NULL, 12342, '/media/sf_www/portail-programme/public/assets/img/brand/kama.png', 'png', 1, 'imagePreview'),
    (NULL, 18238, '/media/sf_www/portail-programme/public/assets/img/brand/cegep-logo-2018.jpg', 'jpg', 1, 'cover'),
    (NULL, 7883, '/media/sf_www/portail-programme/public/assets/img/brand/blue.png', 'png', 1, 'image');

    INSERT INTO SubmissionHistory (id, submissionId, correctionTime) VALUES
    (100, 100, CURRENT_TIMESTAMP);

    INSERT INTO Quiz(code, title, isStarted, courseId) VALUES
    ('QUIZ1234', 'Quiz test', FALSE , 1),
    ('QUIZ4321', 'Quiz test #2', FALSE ,  1),
    ('QUIZ6969', 'Quiz test #3', FALSE , 1);

    INSERT INTO Question(id, title, explanation, type, quizCode, isActive) VALUES
    (DEFAULT, 'Que signifie PHP?', 'Parce que', 1, 'QUIZ1234', FALSE),
    (DEFAULT, 'Qui est Martin Sandwich?', 'Parce que', 3, 'QUIZ1234', FALSE);

    INSERT INTO AnswerChoice(id, description, isGood, questionId) VALUES
    (DEFAULT, 'PHP Hypertext Preprocessor', true, 1),
    (DEFAULT, 'PHP High Preprocessor', false, 1),
    (DEFAULT, 'Pre Hypertext Processor', false, 1),
    (DEFAULT, 'Une légende', true, 2);

    INSERT INTO `Transaction` (transactionId, studentId, date, fluctuation, currentCredit, description) VALUES
    (null, 7, '2020-01-27 12:10:18', 50, 50, 'Vous avez reçu 50c par l''accomplissement de l''exercice Avion.'),
    (null, 7, '2020-01-27 12:10:19', 200, 250, 'Vous avez reçu 200c par l''accomplissement de l''exercice Tic-Tac-Toe.'),
    (null, 7, '2020-01-27 12:10:20', 150, 400, 'Vous avez reçu 150c par l''accomplissement de l''exercice Kanu.');

    INSERT INTO Correction (id, submissionId, date, result, comments) VALUES
    (null, 1, CURRENT_TIMESTAMP, 1, 'Tien Dave'),
    (null, 1, CURRENT_TIMESTAMP, 1, 'Tien Dave1'),
    (null, 1, CURRENT_TIMESTAMP, 1, 'Tien Dave2'),
    (null, 1, CURRENT_TIMESTAMP, null, 'Tien Dave3'),
    (null, 1, CURRENT_TIMESTAMP, 0, 'Tien Dave4');
