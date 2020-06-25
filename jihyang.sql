SELECT * 
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT * 
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;


expression: 컬럼값을 가공을 하거나, 존재하지 않는 새로운 상수값(정해진 값)을 표현
            연산을 통해 새로운 컬럼을 조회할 수 있다.
            연산을 하더라도 해당 sql 조회 결과에만 나올 뿐이고 실제 테이블의 데이터에는
            영향을 주지 않는다
            SELECT 구분은 테이블의 데이터에 영향을 주지 않음;
        


SELECT sal, sal + 500 , sal - 500 , sal/5 , sal*5 , 500
FROM emp;

날짜에 사칙연산 : 수학적으로 정의가 되어 있지 않음
SQL에서는 날짜데이터 +-정수  =>> 정수를 일수 취급
'2020년 6월 25일' + 5 : 2020년 6월 25일부터 5일 이후 날짜
'2020년 6월 25일' - 5 : 2020년 6월 25일부터 5일 이전 날짜

데이터 베이스에서 주로 사용하는 데이터 타입 숫자, 문자, 날짜

empno : 숫자
ename : 문자
job : 문자
mgt : 숫자
hiredate : 날짜
sal : 숫자
comm : 숫자
deptno : 숫자

테이블의 컬럼구성 정보 확인 :
DESC 테이블명 (DESCRIBE 테이블명)

DESC emp;

SELECT *
FROM dept;

파일시스템과 다른점 파일시스템에서는 비어있는 정보가 있어도 저장되지만 sql에서는 정보가 비어있으면 저장되지 않음

SELECT hiredate, hiredate + 5, hiredate - 5
FROM emp;

*users 테이블의 컬럼 타입을 확인하고 
reg_dt 컬럼 값의 5일 뒤 날짜를 새로운 컬럼으로 표현
조회 컬럼 : userid, reg_dt, reg_dt의 5일 뒤 날짜

DESC users;

SELECT userid, reg_dt, reg_dt + 5
FROM users;

