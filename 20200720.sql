-------GROUPING(column) : 0, 1 만 리턴하는 함수
0 : 해당 컬럼이 소계 계산에 사용 되지 않았을 때 (GROUP BY 컬럼으로 사용됨)
1 : 해당 컬럼이 소계 게산에 사용 되었을 때

SELECT job, deptno, GROUPING(job), GROUPING(deptno),SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job,deptno);

GROUP_AD2]

job 컬럼이 소계계산으로 사용되어 NULL값이 나온 것인지
정말 컬럼의 값이 null인 행들이 group by 된것인지 알려면
GROUPING 함수를 사용해야 정확한 값을 알 수 있다.

GROUPING(job) 값이 1이면 '총계', 0이면 job => '='비교는 DECODE가 길이가 짧아서 편하다 =가 아니면 CASE 

SELECT DECODE(GROUPING(job), 1, '총계', 0, job) job ,deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job,deptno) ;

NVL 함수를 사용하지않고 GROUPING 함수를 사용해야하는 이유

SELECT job, mgr,GROUPING(job), GROUPING(mgr) ,SUM(sal)
FROM emp
GROUP BY ROLLUP (job,mgr);


SELECT DECODE(GROUPING(job), 1, '총', 0, job) job ,DECODE(GROUPING(deptno), 1, '소계', 0, deptno)deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job,deptno) ;

GROUP_AD2-1]

SELECT DECODE(GROUPING(job), 1, '총', 0, job) job,
       DECODE(GROUPING(deptno), 1, '소계', 0, deptno)deptno, 
       SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job,deptno) ;


SELECT CASE 
        WHEN GROUPING(job) = 1 THEN  '총'
        WHEN GROUPING(job) = 0 THEN  job  
    END job,
        CASE
        WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '계'
        WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 1 THEN '소계'
        WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 0 THEN TO_CHAR(deptno)
    END deptno,SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job,deptno) ;

▼DECODE로 바꾸기 

SELECT DECODE(GROUPING(job), 1, '총', 0, job) job,
       DECODE(GROUPING(job) + GROUPING(deptno),0, TO_CHAR(deptno),
                                               1, '소계',
                                               2, '계') deptno, 
       SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job,deptno) ;



GROUP_AD3]

SELECT deptno, job, SUM(sal+ NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(deptno,job);

GROUP_AD4]

SELECT d.dname, e.job, SUM(sal+ NVL(comm,0)) sal
FROM emp e , dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname,e.job)

선생님 풀이

SELECT deptno, job, SUM(sal+ NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(deptno,job);

SELECT *
FROM
(SELECT deptno, job, SUM(sal+ NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(deptno,job))a

SELECT dept.dname,a.job,a.sal
FROM
(SELECT deptno, job, SUM(sal+ NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(deptno,job))a, dept
WHERE a.deptno = dept.deptno(+);

오라클 기준)) 조인에 실패에해서 데이터가 없는 쪽 컬럼에 + 를 붙혀준다

--> 두개 쿼리를 비교하면 인라인뷰를 사용하지 않는쪽 쿼리를 사용하는게 좋다 


GROUP_AD5]

SELECT DECODE(GROUPING(dname), 1, '총합', dname) dname, e.job, SUM(sal+ NVL(comm,0)) sal
FROM emp e , dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname,e.job)

-->중간 JOB null값에 소계, 마지막에 계 를 채우는 연습으로 복습


확장된 GROUP BY 
1. ROLLUP - 컬럼 기술에 방향성이 존재 왜냐하면 컬럼을 오른쪽부터 제거한 서브그룹을 생성하기 때문에 ★방향성★중요
   GROUP BY ROLLUP(job, deptno) != GROUP BY ROLLUP(deptno,job)
   GROUP BY ROLLUP job, deptno     GROUP BY ROLLUP deptno,job
   GROUP BY ROLLUP job             GROUP BY ROLLUP deptno    
   GROUP BY ROLLUP 전체            GROUP BY ROLLUP 전체
   단점 : 개발자가 필요없는 서브 그룹을 임의로 제거할 수 없다.

2. GROUPING SETS -  필요한 서브그룹을 임의로 지정하는 형태
    ==> 복수의 GROUP BY 를 하나로 합쳐서 결과를 돌려주는 형태
   
    GROUP BY GROUPING SETS(col1,col2)
    GROUP BY col1
    UNION ALL
    GROUP BY col2


    GROUP BY GROUPING SETS(col2,col1)
    GROUP BY col2
    UNION ALL
    GROUP BY col1    

    GROUPING SETS의 경우 ROLLUP과는 다르게 컬럼 나열 순서가 데이터자체에 영향을 미치지않음 
    
    복수 컬럼으로 GROUP BY
    GROUP BY col1,col2
    UNION ALL
    GROUP BY col1    
    ==> GROUPING SETS ((col1, col2), col1)
   
3. CUBE -->가능한 모든조합이라 실무에서는 잘 안쓰임
-->그러나 시험에 잘나오기때문에 정의는 잘 알아둬야함 


GROUPING SETS 실습

SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY GROUPING SETS (job, deptno)

위 쿼리를 UNION ALL로 풀어 쓰기

SELECT job, null deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY job

UNION ALL

SELECT null , deptno, SUM(sal + NVL(comm, 0)) sal_sum
FROM emp
GROUP BY deptno

GROUP BY GROUPING SETS (job, deptno, mgr)
GROUP BY GROUPING SETS ((job, deptno), mgr)

SELECT job, deptno, mgr, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY GROUPING SETS ((job, deptno), mgr)

CUBE
GROUP BY 를 확장한 구문
CUBE절에 나열한 모든 가능한 조합으로 서브그룹을 생성
GROUP BY CUBE(job, deptno);
▼가능한 모든 조합
GROUP BY job, deptno
GROUP BY job
GROUP BY      deptno
GROUP BY

SELECT job, deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY CUBE(job, deptno);

GROUP BY CUBE(job, deptno, mgr); 
==> 서브그룹 갯수가 8개 즉 
2 의 (컬럼수)만큼 제곱 한 수가 행의 수가 됨
기술한 컬럼이 3개만 넘어도 생성되는 서브그룹의 개수가 8개가 넘기때문에
실제 필요하지 않은 서브 그룹이 포함될 가능성이 높다 ==> ROLLUP, GROUPING SETS 보다 활용성이 떨어진다.

GROUP BY job, ROLLUP(deptno), CUBE(mgr) --> 이렇게 배운걸 전부 한번에 쓰는것도 가능
==> 내가 필요로하는 서브그룹을 GROUPING SETS를 통해 정의하면 간단하게 작성 가능.
ROLLUP(deptno) : GROUP BY deptno
                 GROUP BY 전체
CUBE(mgr) : GROUP BY mgr
            GROUP BY 전체
            
GROUP BY job, deptno, mgr 
GROUP BY job, deptno
GROUP BY job, mgr
GROUP BY job

SELECT job, deptno, mgr, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr)

1. 서브그룹을 나열하기 
GROUP BY job
GROUP BY job, deptno
GROUP BY job
GROUP BY job, '전체'
GROUP BY job, mgr
GROUP BY '전체'

2. 서브그룹별로 색상을 칠해보기 

SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, ROLLUP(job, deptno), cube(mgr);
          1      n+1 ==> 3              2 
          
서브쿼리 

SELECT *
FROM emp_test
1. emp_test 테이블을 삭제
DROP TABLE emp_test
2. emp 테이블을 이용해서 emp_test 테이블 생성
CREATE emp_test AS
SELECT *
FROM emp
3. emp_test 테이블에 DNAME   VARCHAR2(14) 컬럼 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));


DROP TABLE emp_test

CREATE TABLE emp_test AS
SELECT *
FROM emp

SELECT *    
FROM emp_test

ALTER TABLE emp_test ADD (dname  VARCHAR2(14));

SELECT empno, ename, deptno, (SELECT dname FROM dept WHERE dept.deptno = emp_test.deptno)
FROM emp_test;

★WHERE 절이 존재하지 않음 ==> 모든 행에 대해서 업데이트를 실행
UPDATE emp_test SET dname = (SELECT dname
                               FROM dept
                              WHERE dept.deptno = emp_test.deptno);
                              
                              
SELECT *
FROM dept_test;
1. dept_test 테이블 삭제
2. dept 테이블을 이용하여 dept_test 생성( 모든행, 모든 컬럼)
3. dept_test 테이블에 empcnt(number) 컬럼을 추가
4. subquery를 이용하여 dept_test 테이블의 empcnt컬럼을 해당 부서원수로 update

1.
DROP TABLE dept_test
2.
CREATE TABLE dept_test AS
SELECT *
FROM dept
3.
ALTER TABLE dept_test ADD (empcnt NUMBER);
4.
UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                               FROM emp
                               WHERE deptno = dept_test.deptno );
상호연관 서브쿼리로 업데이트 하기                         
SELECT COUNT(*)
FROM emp
GROUP BY deptno  --> 전체행을 할땐 그룹바이 함수 쓰지 않음

SELECT *
FROM dept_test

COMMIT