GROUP 함수의 특징
1. NULL은 그룹함수 연산에서 제외가 된다

부서번호별 사원의 SAL, COMM 컬럼의 총 합을 구하기

SELECT deptno, SUM(sal + comm), SUM(sal) + SUM(comm),SUM(sal + NVL(comm,0))
FROM emp
GROUP BY deptno;


SELECT deptno, SUM(sal) + SUM(comm)  -->>SAL은 널이 아니지만 뒤 커미션이 널이기 때문에 최종 결과값이 NULL로나올때
FROM emp                             -->>SAL컬럼이라도 구하고 싶을때는 커미션 컬럼을 널처리 NVL(SUM(comm),0) 혹은
GROUP BY deptno;                     -->>                                             SUM(NVL(comm),0)
                                     -->>                                       //위아래 값이 똑같지만 위가 더 효율적 처리횟수차이


group 실습 1)
emp테이블을 이용하여 다음을 구하라

SELECT MAX(sal) max_sal,MIN(sal) min_sal,ROUND(AVG(sal),2),SUM(sal) sum_sal,NVL(COUNT(sal),0) count_sal,NVL(COUNT(mgr),0) count_mgr,COUNT(*) count_all
FROM emp;


group 실습 2)
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2),SUM(sal) sum_sal,NVL(COUNT(sal),0) count_sal,NVL(COUNT(mgr),0) count_mgr,COUNT(*) count_all
FROM emp
GROUP BY deptno;  


group 실습 3) 그룹2에서 나온 쿼리를 활용하여 부서번호대신 부서명이 나올 수 있도록 수정
SELECT DECODE(deptno,10, 'ACCOUMT', 20, 'RESERCGH', 30, 'SALES', 'DDIT') DNAME,
       MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2),SUM(sal) sum_sal,NVL(COUNT(sal),0) count_sal,NVL(COUNT(mgr),0) count_mgr,COUNT(*) count_all
FROM emp
GROUP BY deptno;  


GROUP 실습 4) 직원이 입사 년월별로 몇명이 입사했는지 
SELECT TO_CHAR(hiredate,'YYYYMM') hire_yyyymm ,NVL(COUNT(ENAME),0) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');

GROUP 실습 4) 선생님 답안
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

GROUP 실습 5) 직원이 입사년별로 몇명이 입사했는지 
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');

GROUP 실습 6) 회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리 작성
SELECT COUNT(*) cnt
FROM dept;

GROUP 실습 7) 직원이 속한 부서의 개수를 조회하는 쿼리 작성
▼ 풀이과정 순서
SELECT deptno
FROM emp;

SELECT deptno
FROM emp
GROUP BY deptno;

(인라인뷰 활용)
SELECT *    
FROM    
    (SELECT deptno
    FROM emp
    GROUP BY deptno);

▼ 다른 풀이과정
SELECT COUNT(COUNT(deptno)) CNT
FROM emp
GROUP BY deptno;

★JOIN★
컬럼을 확장하는 방법(데이터를 연결한다=다른테이블의 칼럼을 가져온다)
RDBMS는 중복을 최소화 하는 형태의 데이터 베이스 다른테이블과 '결합'하여 데이터를 조회
└하나의 테이블에 데이터를 전부 담지 않고, 목적에 맞게 설계한 테이블에 데이터가 분산된다.
하지만 데이터를 조회 할때 다른 테이블의 데이터를 연결하여 컬럼을 가져올 수 있다.

ANSI-SQL : AMERICAN NATIONAL STANDARD INSTITUTE SQL)
ORACLE-SQL 문법

JOIN : ANSI-SQL
       ORACLE-SQL의 차이가 다소 발생

ANSI-SQL JOIN 
NATURAL JOIN : 조인하고자 하는 테이블간 컬럼명이 동일할 경우 해당 컬럼으로 행을 연결 
               컬럼 이름 뿐만아니라 데이터 타입도 동일해야함.
사용예시)
SELECT 컬럼
FROM 테이블1 NATURAL JOIN 테이블2

emp, dept 두테이블의 공통된 이름을 갖는 컬럼 : deptno

조인 조건으로 사용된 컬럼은 테이블 한정자를 붙이면 에러 (ANSI-SQL기준)
SELECT emp.empno, emp.ename, deptno, dept.dname
FROM emp NATURAL JOIN dept;

위의 쿼리를 오라클 버전으로 수정
오라클에서는 조인 조건을 WHERE절에 기술
행을 제한하는 조건, 조인조건 ==> WHERE절에 기술

▼사용예시
SELECT emp.*, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
-->한정자를 붙히지 않으면 어디에서 오는 컬럼인제 모호하다는 에러가 뜨므로 조건절에 한정자를 붙혀줘야함.

#ANSI와 오라클 차이점 중복된컬럼이 각각의 컬럼으로 나오는지 안나오는지

SELECT emp.*, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno != dept.deptno;

ANSI-SQL : JOIN WITH USING
조인 테이블간 동일한 이름의 컬럼이 복수개 인데 이름이 같은 컬럼중 일부로만 조인하고싶을 때 사용

SELECT *
FROM emp JOIN dept USING (deptno);
    
위의 쿼리를 오라클 조인으로 변경하면??

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

ANSI-SQL : JOIN with ON
위에서 배운 NATURAL JOIN, JOIN with USING의 경우 조인 테이블의 조인컬럼이
이름이 같아야 한다는 제약 조건이 있음
설계상 두 테이블의 컬럼 이름 다를 수도 있기 때문에 컬럼 이름이 다를 경우에
개발자가 직접 조인 조건을 기술 할 수 있도록 제공해주는 문법

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT *
FROM emp, dept 
WHERE emp.deptno = dept.deptno;


SELP-JOIN : 동일한 테이블끼리 조인 할 때 지정하는 명칭
            (별도의 키워드가 아니다)
            

사원 번호 , 사원이름, 사원의 상사 사원번호, 사원의 상사이름을 갖고 오고 싶다면?
SELECT *
FROM emp;

KING의 경우 상사가 없기 때문에 조인에 실패한다.
그래서 총 행의 수는 13건이 조회된다
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON( e.mgr = m.empno );

사원중 사원의 번호가 7369~7698인 사원만 대상으로 해당 사원의 
사원번호, 이름, 상사의 사원번호, 상사의 이름

SELECT *
FROM emp 
WHERE empno BETWEEN 7369 AND 7698;


SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON( e.mgr = m.empno )
WHERE e.empno BETWEEN 7369 AND 7698;


SELECT a.*, emp.ename
FROM
    (SELECT empno, ename, mgr
    FROM emp 
    WHERE empno BETWEEN 7369 AND 7698) a, emp
WHERE a.mgr = emp.empno;

▼ANSI-SQL 버전으로 바꾼거
SELECT a.*, emp.ename
FROM
    (SELECT empno, ename, mgr
    FROM emp 
    WHERE empno BETWEEN 7369 AND 7698) a JOIN emp ON (a.mgr = emp.empno);
    
NON-EQIT-JOIN : 조인 조건이 =이 아닌 조인
>> != : 값이 다를 때 연결

SELECT empno, ename, sal            -->>급여등급
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal ;

SELECT *
FROM salgrade;


join 실습 0)

SELECT emp.empno, emp.ename,emp.deptno,dname
FROM emp, dept 
WHERE emp.deptno = dept.deptno;

join 실습 1)
SELECT emp.empno, emp.ename,emp.deptno,dname
FROM emp, dept 
WHERE emp.deptno = dept.deptno 
  AND dept.deptno IN(10, 30); 

