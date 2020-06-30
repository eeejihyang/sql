날짜관련 오라클 내장함수
내장함수 : 탑재가 되어있다.
          오라클에서 제공해주는 함수 (많이 사용하니까, 개발자가 별도로 개발하지 않도록)
(활용도:★) MONTHS_BETWEEN(date1, date2): 두 날짜 사이의 개월 수를 변환 : 1.21231 개월
(활용도:★★★★★) ADD_MONTHS(date1, date2) : DATE 날짜에 NUMBER 만큼의 개월수를 더하고, 뺀 날짜 변환
(활용도:★★★) NEXT_DAY(date1, date2), 주간요일(1~7) : date1 이후에 등장하는 첫번째 주간요일의 날짜 변환
                                                     ex)20200630, 6(금요일) ==>> 20200703
(활용도:★★★) LAST_DAY(date1) : date1 날짜가 속한 월의 마지막 날짜 변환
                                ex)20200605 ==>> 20200630 
                                모든 달의 첫번째 날짜는 1일로 정해져 있지만
                                마지막날짜는 다른경우가 있기 때문에 많이 쓰는편. (28,29,30,31로 다양)
                                
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) 
FROM emp;            

ADD_MONTHS;

SELECT ADD_MONTHS(SYSDATE, 5) aft5, ADD_MONTHS(SYSDATE, -5) bef5
FROM dual;

NEXT_DAY : 해당 날짜 이후에 등장하는 첫번째 주간요일의 날짜
SYSDATE : 2020/06/30일 이후에 등장하는 첫번째 토요일(7)은 몇일인가?

SELECT  NEXT_DAY(SYSDATE, 7)
FROM dual;

LAST_DAY : 해당 일자가 속한 월의 마지막 일자를 변환
SYSDATE : 2020/06/30 실습 당일의 날짜가 월의 마지막이기 때문에 임의 테스트
         (2020/06/05)  
SELECT LAST_DAY(TO_DATE('2020/06/05', 'YYYY/MM/DD'))
FROM dual;
==>>'2020/06/05'가 문자열이기 때문에 TO_DATE를 이용하여 해석오류를 방지하고 
    앞에 알고싶은 내용인 LAST_DAY로 묶어서 실행
    
LAST_DAY는 있는데 , FIRST_DAY ==? 모든 열의 첫번째 날짜는 동일(1일)
FIRST_DAY 직접 SQL로 구현
SYSDATE : 20200630 ==> 20200601

1. SYSDATE를 문자로 변경하는데 포맷은 YYYYMM ==> TO_CHAR(SYSDATE, 'YYYYMM')
2. 1번의 결과에다가 문자열 결합을 통해 '01'문자를 뒤에 붙여준다 ==> TO_CHAR(SYSDATE, 'YYYYMM') || '01'
    YYYYMMDD
3. 2번의 결과를 날짜 타입으로 변경 ==> TO_DATE(CONCAT(TO_CHAR(SYSDATE, 'YYYYMM'), '01'), 'YYYYMMDD')  day

SELECT TO_DATE(CONCAT(TO_CHAR(SYSDATE, 'YYYYMM'), '01'), 'YYYYMMDD')  day
FROM dual;

SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYY/MM/DD') DAY
FROM dual;

★ 문자를 날짜로 바꿨다가 날짜를 다시 문자열로 바꾸는걸 의외로 되게 자주함.
   TO_CHAR->TO_DATE->TO_CHAR

실습3)
SELECT TO_CHAR(LAST_DAY(TO_DATE('2019/12', 'YYYY/MM')),'YYYYMM') PARAM,
       TO_CHAR(LAST_DAY(TO_DATE('2019/12', 'YYYY/MM')),'DD') DT
FROM dual;

SELECT TO_DATE('2019/12', 'YYYY/MM')
FROM dual;

SELECT LAST_DAY(TO_DATE('2019/12', 'YYYY/MM')
FROM dual;

SELECT TO_CHAR(LAST_DAY(TO_DATE('2019/12', 'YYYY/MM')),'DD') DT
FROM dual;

SELECT :param param, TO_CHAR(LAST_DAY(TO_DATE('2019/12', 'YYYY/MM')),'DD') DT
FROM dual;


 
위 실습 문제처럼 요구하는 결과값은 숫자타입이지만 구한식이 문자열인 경우가있다. 이럴때 형변환이 필요할때가 있다.
형변환
-명시적 형변환
-묵시적 형변환

실행계획 : DBMS가 요청받은 sql을 처리하기 위해 세운 절차
          sql 자체에는 로직이 없다. (어떻게 처리해라 정해진것이 없다. <<==JAVA랑 다른점)
▼ 실행계획 보는 방법
1. 실행계획을 생성
EXPLAIN PLAN FOR
실행계획을보고자하는 SQL;

2. 실행계획을 보는 단계
SELECT *
FROM TABLE(dbms_xplan.display);

empno 컬럼은 NUMBER 타입이지만 형변환이 어떻게 일어 났는지 
확인하기 위하여 의도적으로 문자열 상수 비교를 진행

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)

실행계획을 읽는 방법 :
1. 위에서 아래로 
2. 단 자식노드가 있으면 자식노드부터 읽는다
      └자식노드 : 들여쓰기가 된 노드
      
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(TO_CHAR("EMPNO")='7369')



EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69';  -->숫자+문자 배열일때 어떤 취급을 받을지 확인해 보는 샘플

SELECT *
FROM TABLE(dbms_xplan.display);    

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369) -->> 숫자 취급
   

＃숫자문자열,'포맷' 형변환   
6,000,000  <===> 600000
국제화 : i10n
    날자 국가별로 형식이 다르다
    한국 : yyyy-mm-dd
    미국 : mm-dd-yyyy
    숫자
    한국 : 9,000,000.00
    독일 : 9.000.000,00

sal(number) 컬럼의 값을 문자열 포맷팅 적용 예제

SELECT ename, sal, TO_CHAR(sal, 'L9,999.00')
FROM emp;

▼다시 숫자로 변환
SELECT ename, sal, TO_NUMBER(TO_CHAR(sal, 'L9,999.00'), 'L9,999.0')
FROM emp;


● NULL과 관련된 함수 : NULL값을 다른 값으로 치환하거나, 혹은 강제로 NULL을 만드는 것

1. NVL(expr1, expr2)
    if(expr1 == null) expr2를 반환
  else expr1를 반환;
        
SELECT empno, sal, comm, NVL(comm,0), --> 커미션값이 0이면 널값으로, 0이아니면 원래 값을 나오게
       sal + comm, sal + NVL(comm,0)
FROM emp;

2. NVL2(expr1, expr2, expr3)
     if(expr1 != null) expr2를 반환
   else expr3를 반환;

SELECT empno, sal, comm, NVL2(comm, comm, 0),
       sal + comm, sal + NVL2(comm, comm, 0),NVL2(comm, comm+sal, sal)
FROM emp;

3. NULLIF(expr1, expr2) : null값을 생성하는 목적
     if(expr1 == expr2) null를 반환
   else expt1를 반환;

SELECT ename, sal, comm, NULLIF(sal, 3000)
FROM emp;

4. COALESCE(expr1, expr2......) 인자중에 가장 처음으로 null값이 아닌 값을 갖는 인자를 반환
COALESCE(NULL, NULL, 30, NULL, 50) ==> 30
  if(expr1 != pull) expr1을 반환
else COALESCE(expr2, .....)
    
SELECT COALESCE(NULL, NULL, 30, NULL, 50)
FROM dual;

NULL처리 실습
emp테이블에 14명의 사원이 존재, 한명을추가(INSERT)
조회컬럼 : ename, mgr, mgr컬럼 값이 NULL이면 111로 치환한값-NULL이아니면 mgr, 
          hiredate, hiredate가NULL이면 SYSDATE NULL이아니면 hiredate컬럼값
※INSERT는 안배운거기때문에 밑의 형식을 적용한 후에 시작
INSERT INTO emp (empno, ename, hiredate) VALUES (9999, 'brown', NULL);
SELECT *
FROM emp;

＃
SELECT ename, mgr, NVL2(mgr, 111, mgr),hiredate, NVL2(hiredate, SYSDATE, hiredate)
FROM emp;

＊
SELECT ename, mgr, NVL(mgr, 111) , hiredate, NVL(hiredate, SYSDATE)
FROM emp;

실습4)
SELECT empno, ename, mgr, NVL(mgr, 9999),NVL2(mgr, mgr, 9999),COALESCE(mgr, 9999)
FROM emp;

실습5)
SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) 
FROM users
WHERE userid != 'brown';


SELECT ROUND((6/28)*100,2) || '%'
FROM dual;


●Condition(조건)

sql 조건문
CASE 
    WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환할 값
    WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환할 값
    WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환할 값
    ELSE 모든 WHEN절을 만족시키지 못할 때 반활할 기본 값
END ==> 하나의 컬럼으로 취급

emp테이블에 저장된 job컬럼의 값을 기준으로 급여를 인상시키려고 할 때,
sal컬럼과 함께 인상된 sal컬럼의 값을 비교하고 싶은 상황
급여 인상 기준
job이 SALESMAN sal * 1.05
job이 MANAGER sal * 1.10
job이 PRESIDENT sal * 1.2
나머지 기타 직군은 sal로 유지
! (인상된 급여표현) -->> case로 

SELECT ename, job, sal, 
     CASE
         WHEN job = 'SALESMAN' THEN sal * 1.05
         WHEN job = 'MANAGER' THEN sal * 1.10
         WHEN job = 'PRESIDENT' THEN sal * 1.20
         ELSE sal
     END inc_sal 
FROM emp;
-->> end 뒤에 별칭을 적지않으면 엄청 길게 나오니까 별칭 지정. 별칭은 항상 마지막에

실습 1)

SELECT empno, ename,
     CASE
         WHEN deptno = 10 THEN 'ACCOUNTING'
         WHEN deptno = 20 THEN 'RESEARCH'
         WHEN deptno = 30 THEN 'SALES'
         WHEN deptno = 40 THEN 'OPERATIONS'
         ELSE 'DDIT' 
     END dname 
FROM emp;