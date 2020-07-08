1. GROUP BY 여러개의 행을 하나의 행으로 묶는 행위
2. JOIN 
3. 서브쿼리 
    1. 사용위치
    2. 반환하는 행, 컬럼의개수
    3. 상호연관 / 비상호연관
        -> 메인쿼리의 컬럼을 서브쿼리에서 사용하는지(참조하는지) 유무에 따른 분류
        :비상호연관 서브쿼리의 경우 단독으로 실행가능
        :상호연관 서브쿼리의 경우 실행하기 위해서 메인쿼리의 컬럼을 사용하기 때문에
         단독으로 실행이 불가능

sub2 : 사원들의 급여 평균보다 높은 급여를 받는 직원
SELECT *
FROM emp
WHERE sal > 2800;
▼
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
▶서브쿼리에서 사용하는 컬럼이 메인쿼리에 사용되지않아서 
  서브쿼리 단독으로 실행이 가능하기 때문에 비상호 연관 서브쿼리

사원이 속한 부서의 급여 평균보다 높은 급여를 받는 사원 정보 조회
(참고, 스칼라 서브쿼리를 이용해서 해당사원이 속한 부서의
      부서이름을 가져오도록 작성 해봄)

1. 전체사원의 정보를 조회 하되 조인없이 해당 사원이 속한 부서의 부서이름 가져오기

SELECT empno, ename, deptno, 부서명
FROM emp;
▼
SELECT empno, ename, deptno,
      (SELECT dname FROM dept WHERE deptno = emp. deptno) --> 한행에서 일어나는 일이기때문에 deptno를 또 가져다 쓸수 있음
FROM emp; 
▼
SELECT empno, ename, deptno,
      (SELECT dname FROM dept WHERE deptno = emp. deptno)
FROM emp
WHERE sal > 2873;
▼
부서평균 구하기 --> 10,20,30 의 고정값만 바뀌고있음 쿼리를 작성하여 고정값을 작성하지 않도록 
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;

SELECT AVG(sal)
FROM emp
WHERE deptno = 20;

SELECT AVG(sal)
FROM emp
WHERE deptno = 30;
▼
SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno  = e.deptno);
             
기본틀
SELECT *
FROM emp
WHERE sal > (); --> 이 기본틀로 시작 

WHERE 절 : 조회하는 행을 제한할 때 사용 

sub 3 SMITH 와 WARD 사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를  작성

SELECT *
FROM emp
WHERE deptno IN ( 20, 30);
스미스가 속한 부서 번호 
워드가 속한 부서번호

단일 값비교는 = 지만
복수행(단일컬럼) 비교는 IN 으로 해야함
▼여기서 고정값을 쿼리로 대체하는
SELECT *
FROM emp 
WHERE deptno IN (SELECT deptno
                FROM emp 
                WHERE ename IN ('SMITH','WARD'));
서브쿼리 행이 2개이므로 WHERE 절에서 =로 비교하면 안되고 IN으로.



★IN, NOT IN 이용시 NULL값의 존재 유무에 따라 원하지 않는 결과가 나올 수 있다★
NULL과 IN, NULL과 NOT IN
IN ==> ON
NOT IN ==> AND

SELECT *
FROM emp
WHERE mgr IN (7902, null)
==> mgr  = 7902 OR mgr = null --> NULL 비교는 =로 하지않기 때문에(is null 비교) 항상 false
==> mgr 값이 7902 이거나 mgr값이 NULL인 데이터
SELECT *
FROM emp
WHERE mgr IN(7902, null)
==> NOT (mgr = 7902 OR mgr = null)
==> mgr != 7902 AND mgr != null --> NOT IN 연산자 안에 null값이 있으면 항상 FALSE

●pairwise, non-pairwise
한행의 컬럼값을 하나씩 비교하는 것 : non pairwise
한행의 복수 컬럼을 비교하는 것 : pairwise
SELECT *
FROM emp
WHERE job IN ('MANAGER', 'CLERK');

＊pairwise --> 만족시키는 조건이 2개의 행
SELECT *
FROM emp 
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                          FROM emp
                         WHERE empno IN (7499,7782));
＊non-pairwise--> 만족시키는 조건이 4개의 행                       
SELECT *
FROM emp
WHERE mgr IN ( SELECT mgr
                 FROM emp
                WHERE empno IN (7499,7782))
AND deptno IN ( SELECT deptno
                 FROM emp
                WHERE empno IN (7499,7782));
                
                
sub 4)

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept
WHERE deptno NOT IN (10, 20, 30);

▼ 하드코딩을 서브쿼리로 변환

SELECT *
FROM dept 
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     GROUP BY deptno );   
                  
SELECT *
FROM dept 
WHERE deptno NOT IN (SELECT deptno
                     FROM emp );
                     
sub 실습 5
cycle, product 테이블을 이용하여 cid = 1 인 고객이 애음하지 않는 제품 조회
(내가 푼 풀이 -오류 오답 비교용)
SELECT *
FROM cycle, product
WHERE cid = 1 NOT IN (SELECT pnm
                       FROM product);
                    
기본틀
SELECT *
FROM product;
▼ cid 고객이 어떤 제품을 애음하는지 조회
SELECT *
FROM cycle
WHERE cid = 1;
▼ 
SELECT *
FROM product
WHERE pid NOT IN ( 100, 400, 400, 100);
▼
SELECT *
FROM product
WHERE pid NOT IN ( SELECT pid
                    FROM cycle
                  WHERE cid = 1);
                  
sub 6) cycle 테이블을 이용하여 cid=1인 고객이 애음하는 제품중 
             cid=2인 고객도 애음하는 제품의 애음정보 조회


SELECT *
FROM cycle
WHERE pid IN (SELECT pid 
               FROM product
               WHERE );
