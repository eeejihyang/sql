확장된 GROUP BY
==> 서브그룹을 자동으로 생성
    만약 이런 구문이 없다면 개발자가 직접 SELECT 쿼리를 여러개 작성해서
    UNION ALL을 시행 ==> 동일한 테이블을 여러번 조회 ==> 성능 저하
1. ROLLUP
    1-1. ROLLUP절에 기술한 컬럼을 오른쪽에서 부터 지워나가며 서브그룹을 생성
    1-2. 생성되는 서브 그룹 : ROLLUP절에 기술한 컬럼 개수 + 1
    1-3. ROLLUP절에 기술한 컬럼의 순서가 결과에 영향을 미친다.
    
2. GROUPING SETS
    2-1. 사용자가 원하는 서브그룹을 직접 지정하는 형태
    2-2. 컬럼 기술의 순서는 결과 집합에 영향을 미치지 않음(집합)
    
3. CUBE
    3-1. CUBE절에 기술한 컬럼의 가능한 모든 조합으로 서브그룹을 생성
    3-2. 서브그룹이 2^(큐브절에 기술한 컬럼개수) 만큼 생성되기때문에 서브그룹이 너무많이 생겨 잘 안쓴다.

상호연관 서브쿼리를 이용한 삭제
SUB_A2]

1.dept_test 테이블의 empcnt 컬럼 삭제
ALTER TABLE dept_test DROP (empcnt)

2. 2개의 신규 데이터 입력
INSERT INTO dept_test VALUES (99, 'ddit1', 'daejeon')
INSERT INTO dept_test VALUES (98, 'ddit2', 'daejeon')

3. 부서(dept_test)중에 직원이 속하지 않은 부서를 삭제
삭제 대상 : 40, 98 , 99
1. 비상호연관
SELECT *
FROM dept_test
WHERE deptno NOT IN (10, 20, 30);
▼
SELECT *
FROM dept_test
WHERE deptno NOT IN (SELECT deptno FROM emp);-->여기서 GROUP BY를 해도되고 안해도된다.
▼
DELETE *
FROM dept_test
WHERE deptno NOT IN (SELECT deptno FROM emp);

2. 상호연관 -->EXIST

SELECT *
FROM dept_test
WHERE NOT EXIST ( SELECT 'X'
                   FROM emp
                  WHERE emp.deptno = dept_test.deptno);

2-2 상호연관 NOT IN으로 풀어보기 
SELECT *
FROM dept_test
WHERE deptno NOT IN (SELECT deptno
                       FROM emp
                     WHERE emp.deptno = dept_test.deptno)

SELECT *
FROM emp_test

SUB_A3] --> 잘모르겠으면 하드코딩부터 해보기

SELECT *
FROM emp_test t
WHERE sal < (SELECT AVG(sal)
             FROM emp e
             WHERE t.deptno = e.deptno)

SELECT sal + 200
FROM emp_test 

UPDATE emp_test t SET sal = sal + 200 
WHERE sal < (SELECT AVG(sal)
               FROM emp e
              WHERE t.deptno = e.deptno)

SELECT *
FROM emp_test

ROLLBACK

중복제거 
SELECT DISTINCT deptno
FROM emp
--> GROUP BY 랑 동일한 형태 
CROSS JOIN처럼 중복되는 행이 많이나올때 쓰는게 X ---> JOIN을 바로잡아야함

――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
WITH  -->오라클클럽 질문할때 쓴다고 생각하면 될정도로 잘 안씀
쿼리 블럭을 생성하고 같이 실행되는 SQL에서 해당 쿼리 블럭을 반복적으로 사용할 때
성능 향상 효과를 기대할수 있다.
WITH절에 기술된 쿼리 블럭은 메모리에 한번만 올리기 때문에 쿼리에서 반복적으로 사용하더라도 
실제 데이터를 가져오는 작업은 한번만 발생

하지만 하나의 쿼리에서 동일한 서브쿼리가 반복적으로 사용된다는 것은 쿼리를 잘못 작성할
가능성이 높다는 뜻이므로 WITH절로 해결하기 보다는 쿼리를 다른반식으로 작성할 수 없는지 먼저 고려해볼것.

회사의 DB같은 경우 외부인에게 오픈할 수 없기 때문에, 외부인에게 도움을 구하고자 할때 테이블을
대신할 목적으로 사용할 수 있음

사용방법 : 쿼리블럭은 콤마(,)를 통해 여러개를동시에 선언하는 것도 가능
WITH 쿼리블럭 이름 AS ( 
                        SELECT 쿼리 
                     )
SELECT *
FROM 쿼리블럭 이름;
――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

계층형쿼리 달력만들기

'202007' 의 달력을 만든다고 가정했을 때
1. 2020년 7월의 일수 구하기 
SELECT *
FROM dual
CONNECT BY LEVEL <= 31;
--> 여기서 중요한건 일수는 달마다 달라지기 때문에 레벨 <= 뒤에 하드코딩을 하는것이 아님.
SELECT TO_CHAR(LAST_DAY(TO_DATE('202007', 'YYYYMM')),'DD')
FROM DUAL

SELECT dual.*, level
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202007', 'YYYYMM')),'DD');
▼
SELECT TO_DATE('202007','YYYYMM') + (LEVEL-1)
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202007', 'YYYYMM')),'DD');

요일컬럼 추가하기

SELECT TO_DATE('202007','YYYYMM') + (LEVEL-1),
       TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D')
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202007', 'YYYYMM')),'DD');

(첫번째 컬럼) 일요일이면 날짜출력 일요일이 아니면 NULL 
(두번째 컬럼) 월요일이면 날짜출력 월요일이 아니면 NULL 
(세번째 컬럼) 화요일이면 날짜출력 화요일이 아니면 NULL 
(네번째 컬럼) 수요일이면 날짜출력 수요일이 아니면 NULL 
(다섯번째 컬럼) 목요일이면 날짜출력 목요일이 아니면 NULL ...

조건분기 함수/문법중 골라서 사용 
 
SELECT TO_DATE('202007','YYYYMM') + (LEVEL-1),
       DECODE(TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D'), 1, TO_DATE('202007','YYYYMM') + (LEVEL-1)) SUN,
       DECODE(TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D'), 2, TO_DATE('202007','YYYYMM') + (LEVEL-1)) MON,
       DECODE(TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D'), 3, TO_DATE('202007','YYYYMM') + (LEVEL-1)) TUE,
       DECODE(TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D'), 4, TO_DATE('202007','YYYYMM') + (LEVEL-1)) WEN,
       DECODE(TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D'), 5, TO_DATE('202007','YYYYMM') + (LEVEL-1)) THU,
       DECODE(TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D'), 6, TO_DATE('202007','YYYYMM') + (LEVEL-1)) FRI,
       DECODE(TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D'), 7, TO_DATE('202007','YYYYMM') + (LEVEL-1)) SAT
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202007', 'YYYYMM')),'DD');

위의 쿼리를 가독성을 위해 인라인 뷰로 바꿔주면

SELECT dt, d, iw, DECODE(d, 1, dt) SUN ,DECODE(d, 2, dt) MON ,DECODE(d, 3, dt) TUE, 
                  DECODE(d, 4, dt) WEN, DECODE(d, 5, dt) THU ,DECODE(d, 6, dt) FRI,
                  DECODE(d, 7, dt) SAT 
FROM
    (SELECT TO_DATE('202007','YYYYMM') + (LEVEL-1) DT,
            TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D') D,
            TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'IW') IW
     FROM dual   
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202007', 'YYYYMM')),'DD')) ;

여기에 GROUP BY IW 추가 후 ORDER BY

SELECT iw, MAX(DECODE(d, 1, dt)) SUN ,MAX(DECODE(d, 2, dt)) MON ,MAX(DECODE(d, 3, dt)) TUE, 
           MAX(DECODE(d, 4, dt)) WEN, MAX(DECODE(d, 5, dt)) THU ,MAX(DECODE(d, 6, dt)) FRI,
           MAX(DECODE(d, 7, dt)) SAT 
FROM
    (SELECT TO_DATE('202007','YYYYMM') + (LEVEL-1) DT,
            TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D') D,
            TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'IW') IW
     FROM dual   
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202007', 'YYYYMM')),'DD'))
GROUP BY IW 
ORDER BY IW;
--> 일반적인 달력의 형태로 만들기 위해 일요일이면 주차를 +1로 만들어야한다.

SELECT DECODE(d, 1, iw+1, iw),
       MAX(DECODE(d, 1, dt)) SUN ,MAX(DECODE(d, 2, dt)) MON ,MAX(DECODE(d, 3, dt)) TUE, 
       MAX(DECODE(d, 4, dt)) WEN, MAX(DECODE(d, 5, dt)) THU ,MAX(DECODE(d, 6, dt)) FRI,
       MAX(DECODE(d, 7, dt)) SAT 
FROM
    (SELECT TO_DATE('202007','YYYYMM') + (LEVEL-1) DT,
            TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'D') D,
            TO_CHAR(TO_DATE('202007','YYYYMM') + (LEVEL-1), 'IW') IW
     FROM dual   
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202007', 'YYYYMM')),'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);

--> 월을 원하는 월을 입력해야 달력쿼리로 사용할 수 있기 때문에 월을 바인딩 변수로 변경
SELECT DECODE(d, 1, iw+1, iw),
       MAX(DECODE(d, 1, dt)) SUN ,MAX(DECODE(d, 2, dt)) MON ,MAX(DECODE(d, 3, dt)) TUE, 
       MAX(DECODE(d, 4, dt)) WEN, MAX(DECODE(d, 5, dt)) THU ,MAX(DECODE(d, 6, dt)) FRI,
       MAX(DECODE(d, 7, dt)) SAT 
FROM
    (SELECT TO_DATE(:yyyymm,'YYYYMM') + (LEVEL-1) DT,
            TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') + (LEVEL-1), 'D') D,
            TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') + (LEVEL-1), 'IW') IW
     FROM dual   
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')),'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);
--> iw을 사용하기 때문에 문제발생
-->과제로 문제발생한거 고치기 , 달력의 첫주차 before 일 표기도하기


복습 

create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

SELECT *
FROM sales

일별 실적 데이터를 이용하여 1~6월 월별 실적데이터를 월별 컬럼을 각각 만들어 구하시오-->DECODE를 사용하여 

1. dt컬럼을 이용하여 월 정보 추출 --> DESC 
SELECT TO_CHAR(dt,'MM'), sales
FROM sales;

2. 1번에서 추출된 월정보가 같은 컬럼끼리 sales 컬럼의 합을 계산
SELECT TO_CHAR(dt,'MM'), SUM(sales)
FROM sales
GROUP BY TO_CHAR(dt,'MM')

3. 인라인뷰
SELECT DECODE(M, '01', sales), DECODE(M, '02', sales), DECODE(M, '03', sales), 
       DECODE(M, '04', sales), DECODE(M, '05', sales), DECODE(M, '06', sales)
FORM
(SELECT TO_CHAR(dt,'MM') M, SUM(sales)
FROM sales
GROUP BY TO_CHAR(dt,'MM'))

4. 3번 인라인뷰를 이용 월별 컬럼 6개 생성

SELECT SUM(DECODE(M, '01', sales)), SUM(DECODE(M, '02', sales)), NVL(SUM(DECODE(M, '03', sales)),0), 
       SUM(DECODE(M, '04', sales)), SUM(DECODE(M, '05', sales)), SUM(DECODE(M, '06', sales))
FROM 
(SELECT TO_CHAR(dt,'MM') M, SUM (sales) sales
FROM sales
GROUP BY TO_CHAR(dt,'MM'));

▼
SELECT NVL(SUM(DECODE(M, '01', sales)),0) JAN, NVL(SUM(DECODE(M, '02', sales)),0) FEB, NVL(SUM(DECODE(M, '03', sales)),0) MAR, 
       NVL(SUM(DECODE(M, '04', sales)),0) APL, NVL(SUM(DECODE(M, '05', sales)),0) MAY, NVL(SUM(DECODE(M, '06', sales)),0) JUN
FROM 
(SELECT TO_CHAR(dt,'MM') M, SUM (sales) sales
FROM sales
GROUP BY TO_CHAR(dt,'MM'));

▼
SELECT NVL(SUM(DECODE(TO_CHAR(dt,'MM'), '01', sales)),0) JAN,
       NVL(SUM(DECODE(TO_CHAR(dt,'MM'), '02', sales)),0) FEB,
       NVL(SUM(DECODE(TO_CHAR(dt,'MM'), '03', sales)),0) MAR,
       NVL(SUM(DECODE(TO_CHAR(dt,'MM'), '04', sales)),0) APL,
       NVL(SUM(DECODE(TO_CHAR(dt,'MM'), '05', sales)),0) MAY,
       NVL(SUM(DECODE(TO_CHAR(dt,'MM'), '06', sales)),0) JUN
FROM sales
