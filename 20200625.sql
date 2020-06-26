SELECT empno, ename, sal s, comm AS commition , sal + comm AS sal_plus_comm
FROM emp;

ALIAS : 칼럼이나, expression에 새로운 이름을 부여
적용방법 : 칼럼, expression [AS] 별칭명
별칭을 소문자로 적용 하고 싶은 경우 : 별칭명을 더블 쿼테이션으로 묶는다.
별칭에는 공백을 넣을 수 없기 때문에 언더바 대신 공백을 넣고 싶은 경우에도 별칭명을 더블 쿼테이션으로 묶는다.

SELECT prod_id AS id , prod_name AS name
FROM prod;

SELECT lprod_gu AS gu , lprod_nm AS nm
FROM lprod;

SELECT buyer_id AS 바이어아이디 , buyer_name AS 이름
FROM buyer;

*시험출제 예상 문제
literal : 값 자체
★literal 표기법 : 값을 표기하는 방법 - 언어마다 표기법이 다르기 때문에 중요.
ex : test 라는 문자열을 표기하는 방법
java : System.out.println("test") , java에서는 더블 쿼테이션으로 문자열을 표기한다.
       System.out.println('test') , sql에서는 싱글 쿼테이션으로 표기하면 
       
       
번외
int small = 10;
java 대입 연산자 :       =
pl/sql 대입 연산자 :     :=

언어마다 연산자 표기, literal  표기법이 다르기 때문에 해당 언어에서 지정하는 방식을 잘 따라야 한다

문자열 연산 : 결합
일상생활에서 문자열 결합 연산자가 존재?
java에서 문자열 결합연산자 : +
sql에서 문자열 결합 연산자 : ||
sql에서 문자열 결합 함수 : CONCAT(문자열1, 문자열2) ==> 문자열 1||문자열2
                        두개의 문자열을 인자로 받아서 결합 결과를 리턴
                        
users 테이블의 userid 컬럼과 usernm 컬럽을 결합

SELECT CONCAT(userid, usernm) 
FROM users;

임의 문자열 결합 (sal+500, '아이디 :' || userid)

SELECT '아이디 :' || userid, 500, 'test'
FROM users;

NULL : 아직 모르는 값, 아직 정해지지 않은 값
    1. NULL과 숫자 타입 0은 다르다
    2. NULL과 문자타입 ''은 다르다
    3. NULL값을 포함한 연산의 결과는 NULL : 필요한 경우 NULL값을 다른값으로 치환

SELECT TABLE_NAME
FROM user_tables;

SELECT *
FROM user_tables;

SELECT 'SELECT * FROM '|| TABLE_NAME || ';'
FROM user_tables;

SELECT CONCAT(CONCAT('SELECT * FROM ', TABLE_NAME), ';')
FROM user_tables;

★WHEHE : 테이블에서 조회할 행의 조건을 기술
        WHERE 절에 기술한 조건이 *참*일 때 해당 행을 조회한다.
        sql에서 가장 어려운 부분, 많은 응용이 발생하는 부분
        사용 가능한 연산자 : =, !=, <>, >=, <=, >, <
        
SELECT *
FROM users
WHERE userid = 'brown';

emp 테이블에서 deptno(=소속부서 번호) 칼럼의 값이 30보다 크거나 같은 행을 조회, 칼럼은 모든 칼럼 
SELECT *
FROM emp
WHERE deptno >= '30';


emp 총 행수 : 14
SELECT *
FROM emp
WHERE 1 = 1;

논리성만 생각하면 된다. 조건이 참인지 거짓인지

DATE 타입에 대한 WHERE절 조건 기술
emp 테이블에서 hiredate 같이 1982년 1월 1일 이후인 사원들만 조회
sql에서 DATE 리터럴 표기법 : 'YY/MM/DD';
                           'RR/MM/DD'; 
                           단 서버 설정마다 표기법이 다르다
                           한국 : YY/MM/DD
                           미국 : MM/DD/YY
                           "12/11/01" 라는 조건 값을 구했을 때 한국과 미국의 해석이 다르기 때문에 위 표기는 사용하지 않음
                            DATE  리터럴 보다는 문자열을 DATE 타입으로 변경해주는 함수를 사용.
                            TO_DATE('날짜문자열', '첫번째 인자의 형식')
                                                ㄴ날짜문자열 배치 풀이
SELECT *
FROM emp
WHERE hiredate >= '82/01/01';

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YY/MM/DD');

SELECT *
FROM NLS_SESSION_PARAMETERS;

BETWEEN AND : 두 값 사이에 위치한 값을 참으로 인식
사용방법 비교값 BETWEEN 시작값 AND 종료값
비교값이 시작값과 종료값을 표함하여 사이에 있으면 참으로 인식 

emp 테이블에서 sal 값이 1000보다 크거나 같고 2000보다 작거나 같은 사원들만(행들만) 조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

sal BETWEEN 1000 AND 2000 조건을 부등호로 나타내면 (>=, <=, >, <)?
sal >= 1000 이면서 sal <= 2000

SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000;

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01', 'YY/MM/DD') AND TO_DATE('1983/01/01', 'YY/MM/DD');  

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YY/MM/DD')
  AND hiredate <= TO_DATE('1983/01/01', 'YY/MM/DD');  
  
  위아래 연산자 차이는 값을 포함하느냐 안하느냐 차이인데 비트윈 연산자는 항상 값을 포함하고 있어야함

IN : 특정 값이 나열된 리스트에 포함되는지 검사 ==> OR연산자로 대체 가능
  
SELECT *
FROM emp
WHERE deptno IN (10, 20)

예시)
SELECT *
FROM emp
WHERE deptno = 10
  AND deptno = 20;
AND가 들어가있다면 두개의 조건이 둘다 참이어야 하기 때문에  AND조건은 사용 불가

SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;

IN 연산자 : 비교값이 나열된 값에 포함될 때 참으로 인식
사용방법 : 비교값 IN(비교대상 값1, 비교대상 값2, 비교대상 값3)

사원의 소속 부서가 10번 호은 20번인 사원을 조회하는 sQl을 IN 연산자로 작성

SELECT *
FROM emp
WHERE deptno IN (10, 20);

IN 연산자를 사용하지 않고 OR 연산(논리연산)을 통해서도 동일한 결과를 조회하는 SQL 작성 가능

SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;


SELECT *
FROM emp
WHERE 10 IN (10, 20);
=10이라는 숫자가 10 또는 20에 포함되는가? =참 이기 때문에 emp 전부 나타남 조건을 전부 만족하기 때문에.

SELECT userid 아이디, usernm 이름, AS 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

