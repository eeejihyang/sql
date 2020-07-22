mybatis
SELECT : 결과가 1건이거나 복수거나 
   1건 : sqlSession.selectiOne("네임스페이스.sqlid", [인자]) ==> overloading
         리턴타입 : resultType
  복수 : sqlSession.selectiList("네임스페이스.sqlid", [인자]) ==> overloading
         리턴타입 : 
         
         
―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
오라클 계층쿼리 : 하나의 테이블 ( 혹은 인라인 뷰)에서 특정행을 기준으로 다른행을
                찾아가는 문법
조   인 : 테이블 ― 테이블
계층쿼리 :    행 ― 행

1. 시작점(행)을 설정 [START WITH condition]
2. 시작점(행)과 다른행을 연결시켜주는 조건 기술.

1. 시작점 : mgr 정보가 없는 KING 부터 시작.
2. 연결하는 로직 : KING을 mgr컬럼 값으로 갖는 사원.

SELECT *
FROM emp
START WITH empno = 7839, ename = 'KING', mgr IS NULL;  
-->이런식의 만족하는 여러 조건중 하나 골라서

SELECT *
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;
 
--> 계층쿼리에선 레벨을 쓸수있음 
SELECT emp.*, LEVEL
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

-->내가 15글자 짜리 문자열을 만드는데 만약에 15글자가 안되면 왼쪽에 *를 붙히겠다
SELECT LPAD('기준문자열', 15,'*')
FROM dual;

-->이걸 활용해서 3번째를 주지않으면 공백으로 나옴 
SELECT LPAD('기준문자열', 15)
FROM dual;

-->계층형쿼리에 적용하면
LEVEL = 1 : 0
LEVEL = 2 : 4
LEVEL = 3 : 8

SELECT LPAD(' ', (LEVEL-1)*4) || ename, LEVEL
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;



SELECT LPAD(' ', (LEVEL-1)*4) || ename, LEVEL
FROM emp
START WITH ename = 'BLAKE'
CONNECT BY PRIOR empno = mgr;

하향,상향의 다른점은 -->조회되는 결과 건수가 다름

계층쿼리 상향식 
최하단 노드에서 상위 노드로 연결하는 상향식 연결방법
시작점 : SMITH

SELECT *
FROM emp
START WITH ename = 'SMITH'
CONNECT BY PRIOR mgr = empno;

▼LPAD를 활용하여 
SELECT LPAD(' ', (LEVEL-1)*4) || ename
FROM emp
START WITH ename = 'SMITH'
CONNECT BY         PRIOR mgr = empno;
--> CONNECT BY와 PRIOR는 서로 관계없다 서로 연결된 키워드가 아님.  즉 
CONNECT BY empno = PRIOR mgr 라고해도 값이 같음.   
-->PRIOR 키워드는 현재 읽고 있는 행을 지칭하는 키워드. 
SELECT LPAD(' ', (LEVEL-1)*4) || ename
FROM emp
START WITH ename = 'SMITH'
CONNECT BY empno = PRIOR mgr 

-->앞으로 연결을할때 부서번호가 20번인 대상과 연결하겠다
SELECT LPAD(' ', (LEVEL-1)*4) || ename
FROM emp
START WITH ename = 'SMITH'
CONNECT BY empno = PRIOR mgr AND deptno = 20;


-->PRIOR키워드는 한번이상 올 수도 있다.
SELECT LPAD(' ', (LEVEL-1)*4) || ename, emp.*
FROM emp
START WITH ename = 'SMITH'
CONNECT BY empno = PRIOR mgr AND PRIOR hiredate < hiredate;


SELECT *
FROM dept_h


실습 1)
XX회사 부서부터 시작하는 하향식 계층쿼리 작성, 부서이름과 LEVEL컬럼을 이용하여

SELECT LPAD(' ',(LEVEL-1)*4)||deptnm
FROM dept_h
START WITH deptnm = 'XX회사' -->p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd ;

SELECT LPAD(' ',(LEVEL-1)*4)||deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd ;

선생님쿼리
SELECT deptnm
FROM dept_h
START WITH deptnm = 'XX회사' -->XX회사부터 시작하는 하향식 쿼리를 작성하라 즉 여기가 최상위 노드
CONNECT BY PRIOR deptcd = p_deptcd; --> 내가지금 읽고있는 컬럼을 부모노드로 가질 앞으로 읽을컬럼을 조회 

실습 2)

SELECT LPAD (' ',(LEVEL-1)*4) ||deptnm
FROM dept_h
START WITH deptnm = '정보시스템부'
CONNECT BY PRIOR deptcd = p_deptcd;


실습 3)

디자인팀에서 시작하는 상향식 계층 쿼리

SELECT LPAD (' ',(LEVEL-1)*4) ||deptnm
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd;

