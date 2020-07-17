SQL-응용 : DML (SELECT, UPDATE, INSERT, MERGE)

1. Multiple Insert (잘 사용하지 않음)
   한번에 INSERT 구문을 통해 여러 테이블에 데이터를 입력.
RDBMS : 데이터의 중복을 최소화한다고 배웠으므로 즉 위는 잘 사용하지는 않음.
실 사용예 : 1. 실제 사용할 테이블과 별개로 보조 테이블에도 동일한 데이터 쌓기
           2. 데이터의 수평분할 (*)
              수평분할 예)  주문테이블 
                2020년 데이터 ==> TB_ORDER_2020
                2021년 데이터 ==> TB_ORDER_2021
                ==> 오라클 PARTITION 을 통해 더 효과적으로 관리 가능 (정식 버전)
                    하나의 테이블안에 데이터 값에 따라서 저장하는 물리공간이 나뉘어져 있음 
                    :개발자 입장에서는 데이터 입력을 하면 데이터 값에 따라 
                     물리적 공간을 오라클이 알아서 나눠서 저장 

Multiple Insert 종류
1. unconditional insert : 조건과 관계없이 하나의 데이터를 여러 테이블 입력
2. conditional all insert : 조건을 만족하는 모든 테이블에 입력
3. conditional first insert : 조건을 만족하는 첫번째 테이블에 입력


1.DROP TABLE emp_test2
2.emp 테이블의 empno 컬럼과 ename 컬럼만갖고 emp_test, emp_test2 생성 단 데이터를 복사하지않음

CREATE TABLE emp_test2 AS
SELECT empno,ename
FROM emp
WHERE 1 != 1;

unconditional insert
아래 두개의 행을 emp_test, emp_test2에 동시 입력하기
하나의 insert 구문 사용
SELECT 9999 empno, 'brown' ename FROM dual
UNION ALL
SELECT 9998 empno, 'sally' ename FROM dual;

INSERT ALL
       INTO emp_test VALUES (empno, ename)
       INTO emp_test2 (empno) VALUES (empno) 
SELECT 9999 empno, 'brown' ename FROM dual
UNION ALL
SELECT 9998 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test2

2. conditional insert
ROLLBACK;
조건 분기 문법 : CASE WHEN THEN END
조건 분기 함수 : DECODE

INSERT ALL
       WHEN empno >= 9999 THEN
            INTO emp_test VALUES (empno, ename)
       WHEN empno >= 9998 THEN
            INTO emp_test2 VALUES (empno, ename)
       ELSE
            INTO emp_test2 (empno) VALUES (empno) 
SELECT 9999 empno, 'brown' ename FROM dual
UNION ALL
SELECT 9998 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test2
==>총 3개의 행 삽임됨. 구분을 통해서 저장이 가능하다 라는걸 알아보는 실습.

3. conditional first insert

INSERT FIRST
       WHEN empno >= 9999 THEN
            INTO emp_test VALUES (empno, ename)
       WHEN empno >= 9998 THEN
            INTO emp_test2 VALUES (empno, ename)
       ELSE
            INTO emp_test2 (empno) VALUES (empno) 
SELECT 9999 empno, 'brown' ename FROM dual
UNION ALL
SELECT 9998 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test2;
==>2개의 행 삽입

merge : 덮어쓰다, 통합하다.
1. 사용자로부터 받은 값을 갖고 테이블 저장 or 수정 
   입력받은 값이 테이블에 존재하면 수정을 하고 싶고     
   입력받은 값이 테이블에 존재하지 않으면 신규 입력을 하고 싶을때 
   
2.  테이블의 데이터를 이용하여 다른 테이블의 데이터를 업데이트 OR INSERT 하고 싶을 때 
    일반 UPDATE 구문에서는 비효율이 존재
    ALLEN의 JOB과 DEPTNO 를 SMITH 사원과 동일하게 업데이트 하고싶을 때
    UPDATE emp SET job = (SELECT job FROM emp WHERE ename = 'SMITH'),
                    deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH')
    WHERE ename = 'ALLEN'                
                    
ex : empno 9999, ename 'brown'
emp 테이블에 동일한 empno가 있으면 ename을 업데이트
emp 테이블에 동일한 empno가 없으면 신규 입력

머지구문을 사용하지 않을때 배운거로만 하는방법
1. 해당 데이터가 존재하는지 확인하는 SELECT 구문 실행
2. 1번 쿼리의 조회 결과가 있으면 
    2.1 UPDATE
3. 1번의 쿼리의 조회 결과가 없으면 
    3.1 INSERT 

1. 
SELECT *
FROM emp
WHERE empno = 9999

2. UPDATE emp SET ename = 'brown'
   WHERE empno = 9999;

3. INSERT INTO emp(empno, ename) VALUES ('brown',9999);

문법
MERGE INTO 테이블명(덮어쓰거나, 신규로 입력할 테이블) alias 
USING ( 테이블명 | view | inline-view ) alias
   ON ( 두 테이블간 데이터 존재 여부를 확인할 조건)
WHEN MATCHED THEN
     UPDATE SET 컬럼1 = 값1,
                컬럼2 = 값2
WHEN NOT MATCHED THEN
     INSERT (컬럼 1, 컬럼 2 ....) VALUES (값1, 값2)
     
ROLLBACK;

1. 7369 사원의 데이터를 EMP_TEST 로 복사 (empno, ename)
    emp => emp_test
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno = 7369

SELECT *
FROM emp_test

emp: 14, emp_test :1 (7369-emp 테이블에도 존재)
emp 테이블을 이용하여 emp_test에 
동일한 empno값이 있으면 emp.test ename 업데이트
동일한 empno값이 없으면 emp테이블의 데이터를 신규 입력 

SELECT *
FROM emp_test a, emp b
WHERE a.empno = b.empno;

MERGE INTO emp_test a
USING emp b
   ON (a.empno = b.empno)
WHEN MATCHED THEN
    UPDATE SET a.ename = b.ename || '_m'
WHEN NOT MATCHED THEN
    INSERT (empno, ename) VALUES (b.empno, b.ename);
    
위의 쿼리를 입력하게 되면 emp_test 테이블에는
7369 사원의 이름이 SMITH_m으로 업데이트 될것이고
7369 조건을 제외한 13명의 사원이 INSERT될것

SELECT *
FROM emp_test;

***merge에서 많이 사용하는 형태
사용자로부터 받은 데이터를 emp_test테이블에
동일한 데이터 존재 유무에 따른 merge
시나리오 : 사용자 입력 empno = 9999, ename = brown

INSERT INTO emp_test VALUES(9999,'brown') 

INSERT INTO emp_test
SELECT 9999, 'brown'
FROM dual;

SELECT * 
FROM emp_test
WHERE emp_test.empno = 9999

MERGE INTO emp_test 
USING dual
    ON (emp_test.empno = :empno)
WHEN MATCHED THEN
    UPDATE SET ename = :ename
WHEN NOT MATCHED THEN
    INSERT VALUES(:empno, :ename);

SELECT *
FROM emp_test
WHERE empno = 9999;

SELECT *
FROM dept_test2

실습 : dept_test3 테이블을 dept테이블과 동일하게 생성 단 10, 20 번 부서 데이터만 복제
      dept 테이블을 이용하여 dept_test3 테이블에 데이터를 merge 
      *머지조건 : 부서번호가 같은데이터 
                동일한 부서가 있을 때 : 기존 loc 컬럼의값 + _m로 업데이트 
                동일한 부서가 없을 때 : 신규 데이터 입력
CREATE TABLE dept_test3 AS
SELECT *
FROM dept
WHERE deptno IN (10, 20)

MERGE INTO dept_test3 a
USING dept b
ON (a.deptno = b.deptno) 
WHEN MATCHED THEN
    UPDATE SET a.loc = b.loc || '_m'
WHEN NOT MATCHED THEN    
    INSERT VALUES(b.deptno, b.dname, b.loc)
    
SELECT *
FROM dept_test3

실습2 ] 사용자 입력받은 값을 이용한 merge 
        사용자 입력 : deptno :9999, dname : 'ddit', loc : 'daejeon'
        dept_test3 테이블에 사용자가 입력한 deptno값과
        동일한 데이터가 있을 경우 : 사용자가 입력한 dname, loc 값으로 두개컬럼 업데이트
        동일한 데이터가 없을 경우 : 사용자가 입력한 deptno, dname, loc 값으로 인서트
        
MERGE INTO dept_test3 a
USING dual
ON (a.deptno = :deptno)
WHEN MATCHED THEN
UPDATE SET a.dname = :dname , a.loc = :loc
WHEN NOT MATCHED THEN
INSERT VALUES(:deptno,:dname,:loc);


★GROUP FUNCTION 응용, 확장★
SELECT deptno,SUM(sal)
FROM emp
GROUP BY deptno
UNION ALL
SELECT null,SUM(sal)
FROM emp
ORDER BY deptno NULLS LAST;

위의 쿼리에서 EMP 테이블을 한번만 읽고서 처리하게끔 응용하기
단 emp 테이블을 14건의 데이터를 다 읽지 않는다면 2번 사용가능 


SELECT DECODE(rn, 1 , deptno, 2, null) deptno,SUM(sum_sal)
        FROM (SELECT deptno, SUM(sal)SUM_SAL
                FROM emp
                GROUP BY deptno)a,
             (SELECT ROWNUM rn
                FROM dept
                WHERE ROWNUM <=2)b
                GROUP BY DECODE(rn, 1 , deptno, 2, null) 
                ORDER BY deptno;

SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno);

ROLLUP : 1. GROUP BY의 확장 구문
         2. 정해진 규칙으로 서브 그룹을 생성하고 생성된 서브 그룹을 
            하나의 집합으로 반환
         3. GROUP BY ROLLUP(col1,col2...)
         4. ROLLUP 절에 기술된 컬럼을 오른쪽에서 부터 하나씩 제거해 가며
            서브 그룹을 생성
            ▶ROLLUP을 사용할 시 방향성이 있기 때문에 컬럼 기술 순서가 다르면 다른결과가 도출됨.
            
예시 : GROUP BY ROLLUP(deptno)
1. GROUP BY deptno ==> 부서번호별 총계
2. GROUP BY '' ==> 전체 총계 
예시 : GROUP BY ROLLUP (job, deptno)
1. GROUP BY job, deptno ==> 담당업무, 부서번호별 총계 
2. GROUP BY job ==> 담당업무별 총계
3. GROUP BY '' ==> 전체 총계

*ROLLUP절에 N개의 컬럼을 기술 했을 때 SUBGROUP의 개수는 : n+1개의 서브그룹 생성 

SELECT job,deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job,deptno);

SELECT job, deptno, GROUPING(job), GROUPING(deptno),SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job,deptno);


SELECT DECODE(GROUPING(job), 1, '총계', job),deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job,deptno) ;






            