DECODE : 조건에 따라 변환 값이 달라지는 함수
        ==> 비교, JAVA (if) , sql - case와 비슷
        단 비교연산이 ( = )만 가능
        case의   WHERE절에 기술할 수 있는 코드는 참 거짓 판단할 수 있는 코드면 가능
        ex : sal > 1000
        이것과 다르게 DECODE 함수에서는 SAL = 1000, SAL = 2000

DECODE는 가변인자(인자의 갯수가 정해지지 않음, 상황에 따라 늘어날 수도 있다)를 갖는 함수
문법 : DECODE(기준값(co1|expression),
             비교값1, 반환값1,
             비교값2, 반환값2,
             비교값3, 반환값3,
             옵션[기준값이 비교값중에 일치하는 값이 없을 때 기본적으로 반환할 값]
             
==> java
if ( 기준값 == 비교값1)
    반환값1을 반환해준다
else if ( 기준값 == 비교값2)
    반환값2을 반환해준다
else if ( 기준값 == 비교값3)    
    반환값3을 반환해준다
else 
    마지막인자가 있을 경우 마지막 인자를 반환하고
    마지막인자가 없을 경우 null을 반환
    
*DECODE 와 CASE 비교 예시

SELECT empno, ename,
     CASE
         WHEN deptno = 10 THEN 'ACCOUNTING'
         WHEN deptno = 20 THEN 'RESEARCH'
         WHEN deptno = 30 THEN 'SALES'
         WHEN deptno = 40 THEN 'OPERATIONS'
         ELSE 'DDIT' 
     END dname 
FROM emp;    

SELECT *
FROM dept;

SELECT empno, ename, DECODE( deptno,
                                    10, 'ACCOUNTING',
                                    20, 'RESEARCH',
                                    30, 'SALES',
                                    40, 'OPERATIONS', 
                                    'DDIT' ) dename
FROM emp;


SELECT ename, job, sal, DECODE( job,
                      'SALESMAN', sal * 1.05,
                      'MANAGER', sal * 1.10,
                      'PRESIDENT', sal * 1.20,
                       sal * 1 ) bonus
FROM emp; 

위의 문제 처럼 job에 따라서 sal를 인상을 한다.
단, 추가조건으로 job이 MANAGER이면서 소속부서가(deptno)가 30(SALES)이면 sal * 1.5

우선 CASE로 풀어볼것
-->where절처럼 조건 여러개 쓰는게 가능.
SELECT ename, job, sal, 
     CASE
         WHEN job = 'SALESMAN' THEN sal * 1.05
         WHEN job = 'MANAGER' AND deptno = 30 THEN sal * 1.5
         WHEN job = 'MANAGER' THEN sal * 1.1 
         WHEN job = 'PRESIDENT' THEN sal * 1.20
         ELSE sal
     END inc_sal 
FROM emp;

위에식에서 CASE로 중첩한것
SELECT ename, job, sal, 
     CASE
         WHEN job = 'SALESMAN' THEN sal * 1.05
         WHEN job = 'MANAGER' THEN
                                    CASE
                                        WHEN deptno = 30 THEN sal * 1.5
                                        ELSE sal * 1.1
                                    END 
         WHEN job = 'PRESIDENT' THEN sal * 1.20
         ELSE sal
     END inc_sal 
FROM emp;


DECODE로 풀어보기 

SELECT ename, job, sal, 
       DECODE( job,
                   'SALESMAN', sal * 1.05,
                   'MANAGER', DECODE(deptno, 30, sal * 1.5, sal * 1.10),
                   'PRESIDENT', sal * 1.20,
                    sal * 1 ) bonus
FROM emp;        

CONDITION 실습 2) -->짝수, 홀수 구분 = MOD로 
                    --> 짝수 => 2로 나눴을 때 나머지가 항상 0
                    --> 홀수 => 2로 나눴을 때 나머지가 항상 1

SELECT empno, ename, hiredate, 
            DECODE(MOD(TO_CHAR(hiredate, 'YYYY'), 2),
                     MOD(TO_CHAR(sysdate, 'YYYY'), 2), '건강검진 대상자' , '건강검진 비대상자') CONTACT_TO_DOCTOR
FROM emp;

실습3)

SELECT userid, usernm, reg_dt,
               DECODE(MOD(TO_CHAR(reg_dt, 'YYYY'), 2),
                            MOD(TO_CHAR(sysdate, 'YYYY'), 2), '건강검진 대상자' ,
                                    '건강검진 비대상자') CONTACT_TO_DOCTOR
FROM users;

★GROUP 함수★
여러개의 행을 입력으로 받아서 하나의 행으로 결과를 리턴하는 함수
SUM : 합계
COUNT : 행의 수
AVG : 평균
MAX : 그룹에서 가장 큰 값
MIN : 그룹에서 가장 작은 값

사용방법
SELECT 행동을 묶을 기준 1, 행동을 묶을 기준 2, 그룹함수 
FROM 테이블
[WHERE]
GROUP BY 행동을 묶을 기준 1, 행동을 묶을 기준 2

부서번호별 sla 컬림의 합
1. 부서번호가 같은 행들을 하나의 행으로 만든다
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno;

2. 부서번호별 가장 큰 급여를 받는 사람 급여 액수

SELECT deptno, SUM(sal), MAX(sal)
FROM emp
GROUP BY deptno;

3. 부서번호별 가장 작은 급여를 받는사람 급여 액수

SELECT deptno, SUM(sal), MAX(sal), MIN(sal)
FROM emp
GROUP BY deptno;

4. 부서번호별 급여 평균액수

SELECT deptno, SUM(sal), MAX(sal), MIN(sal), ROUND(AVG(sal),2) 
FROM emp
GROUP BY deptno;

5. 부서번호별 급여가 존재하는 사람의 수(SAL 컬럼이 null이 아닌 행의 수), * : 그 그룹의 행 수

SELECT deptno, SUM(sal), MAX(sal), MIN(sal), ROUND(AVG(sal),2),
        COUNT(sal),
        COUNT(comm),
        COUNT(*)
FROM emp
GROUP BY deptno;


★그룹함수의 특징 :

1.NULL값을 무시

30번 부서의 사원 6명중 2명은 comm값이   null
SELECT deptno, SUM(comm)
FROM emp
GROUP BY deptno;

2. GROUP BY를 적용 여러행을 하나의 행으로 묶게 되면 SELECT 절에 
   기술할수 있는 칼럼이 제한됨 ==> SELECT 절에 기술되는 일반 컬럼들은( 그룹함수를 적용하지 않은)
   반드시 GROUP BY 절에 기술되어야 한다

SELECT deptno, ename, SUM(SAL)
FROM emp
GROUP BY deptno, ename;


그룹함수를 이해하기 힘들면 ==>>엑셀에 데이터를 그려보자 

단, 그룹핑에 영향을 주지않는 고정된 상수, 함수(날짜함수같은것) 기술하는것이 가능하다.

SELECT deptno, 10, SYSDATE, SUM(SAL)
FROM emp
GROUP BY deptno, ename;


3. 일반함수를 WHERE 절에서 용하는게 가능
   (WHERE UPPER('smith') = 'SMITH';) 
   그룹함수위 경우 WHERE절에서 사용하는게 불가능
   하지만 Having 절에 기술하여 동일한 결과를 나타내 볼 수 있디.

SELECT deptno, SUM(SAL)
FROM emp
GROUP BY deptno
Having SUM(sal) > 9000;

위의 쿼리를 HAVING절 없이 SQL작성 --> in-line view 와 컬럼 별칭설정

SELECT *
FROM (SELECT deptno, SUM(sal) sum_sal
      FROM emp
      GROUP BY deptno) 
WHERE sum_sal > 9000;


SELECT 쿼리 문법 총 정리 
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY

GROUP BY 절에 행을 그룹핑할 기준을 작성 
ex : 부서 번호별로 그룹을 만들경우 
     GROUP BY deptno
     
전체행을 기준으로 그룹핑을하려면 GROUP BY 절에 어떤 칼럼을 기술해야 할까?
emp테이블에 등로한 14명의 사원 전체의 급여 합계를 구하려면??? ==> 결과는 1개의 행
==>>> GROUP BY 절을 기술하지 않는다

29025
SELECT deptno, SUM(sal)
FROM emp;

**
SELECT SUM(sal)
FROM emp
GROUP BY deptno;

GROUP BY절에 기술한 칼럽을 SELECT절에 기술하지 않은 경우??


그룹함수의 제한사항
부서번호별 가장 높은 급여를 받는사람의 급여액
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;