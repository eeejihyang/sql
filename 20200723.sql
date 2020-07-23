실습 3)

디자인팀에서 시작하는 상향식 계층 쿼리

SELECT LPAD (' ',(LEVEL-1)*4) ||deptnm
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd;

계층쿼리 
테이블(데이터셋)의 행과 행사이의 연관관게를 추적하는 쿼리 
ex : emp 테이블 해당 사원의 mgr컬럼을 통해 상급자 추적 가능 
    1. 상급자 직원을 다른 테이블로 관리하지 않음
      1-1. 상급자 구조가 계층이 변경이 되도 테이블의 구조는 변경 할 필요가 없다. (유연한 변경 가능)
    2. join : 테이블 간 연결
              FROM emp, dept
              WHERE emp.deptno = dept.deptno
       계층쿼리 : 행과 행사이의 연결 (자기참조)
                 PRIOR : 현재 읽고 있는 행을 지칭 
                 X : 앞으로 읽을 행 
          
실습 4 ) 복습                  
SELECT *
FROM h_sum

SELECT LPAD (' ',(LEVEL-1)*4) || S_ID  S_ID, VALUE
FROM h_sum
START WITH PS_ID IS NULL
CONNECT BY PRIOR S_ID = PS_ID;

실습 5 ) 복습
SELECT *
FROM no_emp

SELECT LPAD (' ', (LEVEL-1)*4) || ORG_CD ORG_CD, NO_EMP
FROM no_emp
START WITH PARENT_ORG_CD IS NULL
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

가지치기 (pruning branch)
SELECT 쿼리의 실행순서 : FROM -> WHERE -> SELECT -> ORDER BY 
계층쿼리의 SELECT쿼리 실행순서 : FROM -> START WITH , CONNECT BY -> WHERE

계층쿼리에서 행을 조회할 행의 조건을 기술할 수 있는 부분이 2곳.
1. CONNECT BY
2. WHERE : START WITH , CONNECT BY에 의해 조회된 행을 대상으로 적용

SELECT LPAD( ' ', (LEVEL-1)*4)||DEPTNM DEPTNM
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND DEPTNM != '정보기획부' ;
                                    --> 앞으로 읽을 행이 정보기획부가 아닌것만 연결해라

SELECT LPAD( ' ', (LEVEL-1)*4)||DEPTNM DEPTNM
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd 
--> 계층쿼리 실행순서가 다르기 때문에 나오는 값이 다름★★

계층쿼리에서 사용할 수 있는 특수함수
CONNECT_BY_ROOT(col) :최상위 행의 cql컬럼의 값
SYS_CONNECT_BY_PATH (COL, 구분자) : 계층의 순위 경로를 표현
CONNECT_BY_ISLEAF : 해당 행이 NODE(1)인지 아닌지(0)을 표현

SELECT LPAD( ' ', (LEVEL-1)*4)|| deptnm deptnm,
       CONNECT_BY_ROOT(deptnm) ROOT,
       LTRIM(SYS_CONNECT_BY_PATH(deptnm,'-'),'-') PATH,
       CONNECT_BY_ISLEAF ISLEAF
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd ;
-->SYS_CONNECT_BY_PATH만 쓰면 옆에 - 가 보기싫게 붙어서 공백을 제거해주는 TRIM을 이용해 LTRIM 으로하고 '-'으로 옆에를 지워줌
-->INSTR 과 SUBSTR을 섞어서 사용하면 구분자를이용해서 PATH를 잘라낼 수 있다

h 6 ~ 8)
SELECT SEQ, TITLE
FROM board_test
ORDER BY SEQ DESC;

SELECT SEQ, LPAD(' ', (LEVEL-1)*4)||TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR  SEQ = PARENT_SEQ
ORDER BY SEQ DESC;  -->계층형태가 깨지면서 정렬됨

▼

SELECT SEQ, LPAD(' ', (LEVEL-1)*4)||TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR  SEQ = PARENT_SEQ
ORDER SIBLINGS BY SEQ DESC;  -->계층형태가 유지됨

정렬할 때 컬럼은 두개 필요하다. 최상위는 역순 그밑은 순차적으로 컬럼을 한개 더 사용한다면 어떤컬럼을 

SELECT SEQ, LPAD(' ', (LEVEL-1)*4)||TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR  SEQ = PARENT_SEQ
ORDER SIBLINGS BY ,SEQ ;  

ALTER TABLE board_test ADD (gn NUMBER)

UPDATE board_test SET gn = 4
WHERE seq IN (4, 5, 6, 7, 8, 10, 11);

UPDATE board_test SET gn = 1
WHERE seq IN (1, 9);

UPDATE board_test SET gn = 2
WHERE seq IN (2, 3);

SELECT *
FROM board_test

SELECT SEQ, gn, CONNECT_BY_ROOT(seq), LPAD(' ', (LEVEL-1)*4)||TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR  SEQ = PARENT_SEQ
ORDER SIBLINGS BY gn DESC, SEQ ;  

▼ 꼭 gn절을 추가하지않고 CONNECT_BY_ROOT 사용하면 할수있을거 같은데 오더바이절에 CONNECT_BY_ROOT를 쓸수없음 ==> 인라인뷰 

SELECT *
FROM (SELECT SEQ, gn, CONNECT_BY_ROOT(seq) s_gn , LPAD(' ', (LEVEL-1)*4)||TITLE
        FROM board_test
      START WITH PARENT_SEQ IS NULL
      CONNECT BY PRIOR  SEQ = PARENT_SEQ
      ORDER SIBLINGS BY gn DESC, SEQ)
ORDER BY s_gn DESC, seq ;  

SELECT *
FROM (SELECT SEQ, CONNECT_BY_ROOT(seq) s_gn , LPAD(' ', (LEVEL-1)*4)||TITLE
        FROM board_test
      START WITH PARENT_SEQ IS NULL
      CONNECT BY PRIOR  SEQ = PARENT_SEQ
      ORDER SIBLINGS BY gn DESC, SEQ)
ORDER BY s_gn DESC, seq ;  

SELECT SEQ,seq - PARENT_SEQ, LPAD(' ', (LEVEL-1)*4)||TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR  SEQ = PARENT_SEQ
ORDER SIBLINGS BY seq - PARENT_SEQ , seq DESC;

SELECT ename, sal, deptno, ROWNUM sal_rank
FROM
(SELECT ename, sal, deptno 
FROM emp
ORDER BY deptno, sal DESC)

선생님 쿼리 
SELECT ename, sal, deptno 
FROM emp
ORDER BY deptno, sal DESC
▼1. 순위를 매길 대상 : emp 사원 => 14명 
 2.부서별로 인원이 다름 : 

1.
SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <=14;
-->레벨이나 로우넘중에 아무거나 써도됨. 
2. 해당 부서의 부서원수 구하기 ==> 그룹바이 카운트 
SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno;

SELECT a.ename, a.sal, a.deptno, b.lv
FROM 
(SELECT ROWNUM rn, a.*
 FROM 
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a,
 
(SELECT ROWNUM rn, a.lv
FROM 
(SELECT b.deptno, a.lv
    FROM 
    (SELECT LEVEL lv
     FROM dual
     CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp ) a,
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) b
    WHERE a.lv <= b.cnt
    ORDER BY b.deptno, a.lv ) a )b
WHERE a.rn = b.rn;

위와 동일한 동작을 하는 윈도우 함수
윈도우 함수 미사용 : EMP테이블 3번 조회
윈도우 함수 사용 : EMP테이블 1번 조회
SELECT ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC)sal_rank
FROM emp;

윈도우 함수를 사용하면 행간 연산이 가능해짐
==> 일반적으로 풀리지 않는 쿼리를 간단하게 만들 수 있다.
**모든 DBMS가 동일한 윈도우 함수를 제공하지는 않음 ==> 즉 윈도우함수가없을때 위에처럼 만들어서 쓸줄 알아야함. 

문법 : 윈도우 함수 OVER ( [PARTITION BY 컬럼] [ORDER BY 컬럼] [WINDOWING])
PARTITION : 행들을 묶을 그룹 (GROUP BY)
ORDER BY : 묶여진 행들간 순서 (RANK - 순위의 경우 순서를 설정하는 기준이 된다)
WINDOWING : 파티션 안에서 특정 행들에 대해서만 연산을 하고 싶을 때 범위를 지정.
-->SUM이나 COUNT처럼 그룹바이 함수랑 겹치는 함수들은 OVER키워드를 통해 뭔지 알 수 있음


순위 관련함수
1. RANK() : 동일 값일 때는 동일 순위 부여 후 후순위는 중복자 만큼 건너 뛰고 부여 
            1등이 2명이면 후순위는 3등
2. DENSE_RANK() : 동일 값일때는 동일 순위 부여 후 후순위는 이어서 부여
                  1등이 2명이어도 후순위는 2등
3. ROW_NUMBER() : 중복되는 값이 없이 순위 부여 (ROWNUM과 유사)

SELECT ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp;

분석함수 실습 2)
SELECT empno, ename, deptno
FROM emp

SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno

▼이거 두개를 조인해서
SELECT a.*, b.cnt
FROM
(SELECT empno, ename, deptno
FROM emp) a,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b
WHERE a.deptno = b.deptno
ORDER BY a.deptno, a.ename

집계 윈도우 함수 : SUM , MAX , MIN , AVG, COUNT
SELECT empno, ename, sal,deptno, 
       ROUND(AVG(sal) OVER ( PARTITION BY deptno ),2) avg_sal
FROM emp;

SELECT empno, ename, sal,deptno, 
       MAX(sal) OVER ( PARTITION BY deptno )MAX_SAL
FROM emp;

SELECT empno, ename, sal,deptno, 
       MIN(sal) OVER ( PARTITION BY deptno )MIN_SAL
FROM emp;