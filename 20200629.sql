ROWNUM : SELECT 순서대로 행 번호를 부여해주는 가상 컬럼
특징 : WHERE 절에서 사용하는게 가능
     ★ 사용할 수 있는 형태가 정해져 있음
     WHERE ROWNUM = 1; = ROWNUM이 1일 때
     WHERE ROWNUM <=( < ) N; ROWNUM이 N보다 작거나 같은 경우, 작은경우
     WHERE ROWNUM BETEEN 1 AND N; ROWNUM이 1 보다 크거나 같고 N보다 작거나 같은 경우
     
     ==> ROWNUM은 1 부터 순차적으로 읽는 환경에서만 사용 가능 

    ★ 안되는경우
    WHERE ROWNUM = 2;
    WHERE ROWNUM => 2;
    : 1의 값이 없는 경우

ROWNUM 사용 용도 : 페이징 처리
페이징 처리란? 네이버 카페에서 게시글 리스트를 한화면에 제한적인 갯수로 조회(예를 들면 한 화면에 100개)
             카페에 전체 게시글 수는 굉장히 많은데 
            한 화면에 못보여주는데 1. 웹브라우저가 버벅이고 2. 사용자의 사용성이 불편하기 때문에
            그래서 한페이지당 게시글의 건수를 정해 놓고 해당 건수만큼 보여줌 


SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 10; 


ROWNUM 과 ORDER BY
SELECT SQL의 실행순서 : FROM => WHERE => SELECT => ORDER BY


SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

ROWNUM 결과를 정렬 이후에 반영 하고 싶은 경우 ==> IN-LINE-VIEW
VIEW : SQL - DBMS에 저장되어 있는 SQL
IN-LINE : 직접 기술 했다, 어딘가 저장을 한게 아니라 그 자리에 직접 기술


SELECT empno, ename
FROM emp;

SELECT *
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename);

SELECT ROWNUM *
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename);
 ┗ SELECT 절에 *만 단독으로 사용하지 않고 콤마를 통해 
    다른 임의 컬럼이나 expression을 표기한 경우 * 앞에 어떤 테이블(뷰)에서 온것인지
    한정자(테이블 이름, view 이름)을 붙여줘야 한다

table, view 별칭 : table이나 view에서도 SELECT절의 컬럼처럼 별칭을 부여 할 수 있다
                  단 SELECT절처럼 AS 키워드는 사용하지 않는다
                  EX : FROM emp e
                       FROM (SELECT empno, ename
                             FROM emp
                             ODERBY ename) v_emp;

SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename);



요구사항 : 페이지당 10 건의 사원 리스트가 보여야된다
1 page : 1~10
2 page : 11~20
3 page : 21~30
.
.
.
.
.
n page : ((n-1)*10)+1 ~ n * 10

페이징 처리 쿼리 1 page : l~10
SELECT ROWNUM, a.*
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a
WHERE ROWNUM BETWEEN 1 AND 10;   

페이징 처리 쿼리 2 page : 11~20
SELECT ROWNUM, a.*
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a
WHERE ROWNUM BETWEEN 11 AND 20; 
└ROWNUM의 특성으로 1번부터 읽지 않는 형태이기 때문에 정상적으로 동작하지 않는다.

ROWNUM의 값을 별칭을 통해 새로운 컬럼으로 만들고 해당 SELECT sql을 in-line view로
         만들어 외부에서 ROWNUM에 부여한 별칭을 통해 페이징 처리를 한다
         
페이징 처리 쿼리 2 page : 11~20
SELECT *
FROM (SELECT ROWNUM rn, a.*
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 20;      
└SELECT 결과를 테이블 이라고 생각  
└안쪽 괄호부터 풀어가면서 실행해보면 어떤 sql인지 알기쉬움

sql 바인딩 변수 : java 변수
페이지 번호 : page
페이지 사이즈 : pagesize
sql 바인딩 변수 표기 : 변수명 --> : page, :pagesize

바인딩 변수 적용 ((:page - 1) * :pagesize)+1 ~ :page * pagesize
SELECT *
FROM (SELECT ROWNUM rn, a.*
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename) a)
WHERE rn BETWEEN (:page - 1) * :pagesize + 1 AND :page * :pagesize;

FUNCTION : 입력을 받아들여 특정 로직을 수행 후 결과 값을 변환하는 객체
오라클에서의 함수 구분 : 입력되는 행의 수에 따라 
1. Single row function
    하나의 행이 입력되서 결과로 하나의 행이 나온다
2. Multi row function
    여러개의 행이 입력되서 결과로 하나의 행이 나온다 
    
dual 테이블 : oracle의 sys 계정에 존재하는 하나의 행, 하나의 칼럼(dummy)을 갖는 테이블.
             누구나 사용할 수 있도록 권한이 개방됨
dual 테이블 용도
1. 함수 실행 (테스트)
2, 시퀀스 실행
3. merge 구문
4. 데이터 복제***
ex)
*LENGTH 함수 테스트             
SELECT LENGTH('TEST')
FROM dual;

SELECT LENGTH('TEST')
FROM emp;

SELECT LENGTH('TEST'), LENGTH('TEST'), emp.*
FROM dual;

문자열 관련 함수 : 설명은 PT 참고 중요한 부분은 아님.

SELECT CONCAT('Hello', CONCAT(',' , 'World')) concat,
       SUBSTR('Hello, World', 1, 5) substr,
       LENGTH('Hello, World') length,
       INSTR('Hello, World', 'o') instr,
       INSTR('Hello, World', 'o', +1) INSTR('Hello, World', 'o')+1 instr,
       LPAD('Hello, World', 15, ' ') lpad,
       RPAD('Hello, World', 15, ' ') rpad,
       REPLACE('Hello, World', 'o', 'p') replace,
       TRIM(' Hello, World ') trim,
       TRIM( 'd' FROM 'Hello, World') trim,
       LOWER('Hello, World') lower,
       UPPER('Hello, World') upper,
       INNTCAP('Hello, World') initcap
FROM dual;


함수는 WHERE 절에서도 사용 가능
사원 이름이 smith인 사람

SELECT *
FROM emp
WHERE ename = UPPER ('smith'); 
└WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

위와 아래 비교했을때 위의 식이 더 사용하기에 용이함 
★ 밑의 형태는 좌변(=테이블컬럼)을 가공하는 형태기 때문에 사용을 지양 해야한다. 

오라클 숫자 관련 함수
ROUND(숫자, 반올림 기준자리) : 반올림 함수
TRUNC(숫자, 내림 기준자리) : 내림 함수
MOD(피제수, 제수) : 나머지 값을 구하는 함수


SELECT ROUND(105.54, 1) round, 
       ROUND(105.55, 1) round2,
       ROUND(105.55,) round3, 
       ROUND(105.55, -1) round4 
FROM dual;

SELECT ROUND(105.54, 1) round, = 반올림결과가 소수점 첫번째 자리 까지 나오도록
       ROUND(105.55, 1) round2,= 반올림결과가 소수점 첫번째 자리 까지 나오도록
       ROUND(105.55,) round3, 
       ROUND(105.55, -1) round4 = 단 두번째 숫자가 음수이면 해당 자리에서 반올림 = 정수 첫째자리에서 반올림
       
SELECT TRUNC(105.54, 1) trunc, 
       TRUNC(105.55, 1) trunc2,
       TRUNC(105.55,) trunc3, 
       TRUNC(105.55, -1) trunc4 
FROM dual;       


sal를 1000으로 나눴을 때의 나머지 ==> mod함수, 별도의 연산자는 없다
몫 : quotient
나머지 : reminder

SELECT ename, sal, TRUNC(sal/1000), MOD(sal, 1000) reminder
FROM emp;



날짜 관련 함수
SYSDATE:
오라클에서 제공해주는 특수함수
1. 인자가 없어
2. 오라클이 설치된 서버의 현재 년, 월, 일, 시, 분, 초 정보를 반환 해주는 함수 

SELECT SYSDATE
FROM dual;


날짜타입 +- 정수: 정수를 일자 취급 정수만큼 미래 혹은 과거 날짜의 데이트 값을 반환
ex : 오늘 날짜에서 하루 더한 미래 날짜 값은?
SELECT SYSDATE + 1
FROM dual;

ex : 현재 날짜에서 3시간뒤 데이트를 구하려면?
데이트 + 정수(하루)
하루==24시간
1시간 ==> 1/24
3시간 ==> (1/24)*3 == 3/24

1분 : 1/24/60

SELECT SYSDATE + (1/24/60)*30
FROM dual;

SELECT SYSDATE + (1/23)*3
FROM dual;

데이트 표현하는 방법
1. 데이트 리터럴 : NSL_SESSION_PARATER 설정에 따르기 때문에 DBMS환경 마다 다르게 인식될 수 있음

2. T0_DATE : 문자열을 날짜로 변경해 주는 함수 


Function date 실습

1. 2019년 12월 31일을 date 형으로 표현
2. 2019년 12월 31일을 date 형으로 표현하고 5일 이전 날짜
3. 현재날짜
4. 현재날짜에서 3일 전 값

SELECT TO_DATE('20191231', ) LASTDAY,
       TO_DATE('20191231', )LASTDAY_BEFORE
       TO_DATE('20191231', ) NOW,
       TO_DATE('20191231', )NOW_
BEFORE
FROM dual;


문자열을 ==> 데이트
TO_DATE(날짜 문자열, 날짜 문자열의 패턴);

데이트 ==> 문자열 (보여주고 싶은 형식을 지정할 때)
TO_DATE(데이트값, 표현하고싶은 문자열 패턴)

SYSDATE 현재 날짜를 년도 4자리-월2자리-일2자리
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD')
       TO_CHAR(SYSDATE, '0'), TO_CHAR(SYSDATE, 'IW')
FROM dual;

날짜 포맷 : PT참고

YYYY
MM
DD
HH24
MI
SS

D, IW

SELECT ename, hiredate, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') h1
       TO_CHAR(hiredate + 1, 'YYYY/MM/DD HH24:MI:SS') h2
       TO_CHAR(hiredate, + 1/24 'YYYY/MM/DD HH24:MI:SS') h3
FROM emp;

FN2)오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오
1. 년-월-일
2. 년-월-일 시간(24)-분-초
3. 일-월-년

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

