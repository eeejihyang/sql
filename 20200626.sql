WHERE 절에서 사용 가능한 연산자 : LIKE
사용용도 : 문자의 일부분으로 검색을 하고 싶을 때 사용
ex : ename 칼럼의 값이 s로 시작하는 사원들을 조회
사용방법 : 칼럼 LIKE '패턴문자열'
★마스컴 문자열 : 1. % : 문자가 없거나, 어떤 문자든 여러개의 문자열
                'S%' : S 로 시작하는 모든 문자열
              2. _ : 어떤 문자든 딱 하나의 문자를 의미 
                'S_' : S 로 시작하고 두번째 문자열이 어떤 문자든 하나의 문자고 오는 2자리 문자열 %와 다르게 어떤문자든 하나는 와야함.
                'S____': S로 시작하고 전체 문자열의 길이가 5글자인 문자열
emp테이블에서 ename 칼럼의 값이 2로 시작하는 사원들만 조회

* where실습 4~5  (조건에 맞는 데이터 조회하기)              

SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

UPDATE member set mem_name= '쁜이'
WHERE mem_id = 'b001';

c001        신용환 ==> 신이환
UPDATE member  SET mem_name = '신이환'
WHERE mem_id = 'c001';

NULL 비교 : = 연산자로 비교 불가 ==> Is
NULL을 = 비교하여 조회

where6)
Comm 컬럼의 값이 null인 사원들만 조회
SELECT empno, ename, comm
FROM emp
WHERE comm IS NULL; 

emp 테이블에서 comm 값이 NULL이 아닌 데이터를 조회 =>> AND, OR, NOT
SELECT empno, ename, comm
FROM emp
WHERE comm IS NOT NULL;

논리연산자 : AND, OR, NOT
AND : 참 거짓 판단식1 AND 참 거짓 판단식 2 ==> 식 두개를 동시에 만족하는 행만 참
      일반적으로 AND 조건이 많이 붙으면 조회되는 행의 수가 줄어든다 
      
OR  : 참 거짓 판단식1 OR  참 거짓 판단식 2 ==> 식 두개중 하나라도 만족하면 참

NOT : 조건을 반대로 해석하는 부정형 연산
     NOT IN 포함되지 않는 값
     IS NOT NULL NULL이 아닌 값
     

emp 테이블에서 MGR 컬럼 값이 7698이면서 SAL 컬럼의 값이 1000보다 큰 사원 조회
2가지 조건을 동시에 만족하는 사원 리스트
SELECT *
FROM emp
WHERE mgr = 7698
AND sal > 1000;

MGR 값이 7698이거나 (5명)
SAL 값이 1000보다 크거나(12명) 두개의 조건 중 하나라도 만족하는 행을 조회
SELECT *
FROM emp
WHERE mgr = 7698
OR sal > 1000;

emp 테이블에서 mgr가 7698, 7839가 아닌 사원들을 조회

SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);

MGR 사번이 7698이 아니고, 7839가 아니고, NULL이 아닌 직원들을 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
하면 데이터 값이 안나옴
mgr가 (7698, 7839, NULL)에 포함된다
mgr IN (7698, 7839, NULL) ==> mgr = 7698 OR mgr = 7839 OR mgr = NULL
mgr NOT IN (7698, 7839, NULL); ==> mgr != 7698 OR mgr != 7839 OR mgr != NULL
그런데 NULL은 !=로 표현할 수 없기 때문에 값이 false여서 데이터 출력 안됨

SELECT *
FROM emp
WHERE mgr != 7698 OR mgr != 7839 OR mgr != NULL;

SELECT *
FROM emp
WHERE mgr = 7698 OR mgr = 7839 OR mgr = NULL;

=즉 IN 연산자는 값이 나오더라도 NOT IN 연산자는 NULL값 때문에 값이 안나올 수도 있음. 

  
mgr IN (7698, 7839)  ==>> or mrg 값이 7698 이거나 7839 인 값 
여기서 부정인 NOT연산자를 붙히게 되면
!(mgr = 7698 OR mgr = 7839) ==>> (mgr != 7698 AND mgr != 7839) 
 부정연산자 NOT 이 전체항에 해당되기 때문에 OR 연산자 또한 AND값으로 변환되어 
 만약 칼럼에 NULL값이 있을경우 NULL값은 비교연산이 불가하기 때문에 NULL을 갖는 행은 무시가된다.
 
where 7 실습)
emp 테이블에서 job이 salesman이고 입사일자가 1901년 6월 1일 이후인 직원의 정보를 조회하세요
(★''안에 들어가는 데이터는 대소문자 구분을 꼭 해줘야함)
(날짜 타입 표기법은 TO_DATE 함수형으로 변환해서 해줄것)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= '1981/06/01';
  
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
  
where 8 실습)
emp  테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회
1. 부서번호가 10번이 아니고 2. 입사일자가 81년 6월 1일 이후

SELECT *
FROM emp
WHERE deptno != 10
AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

where 9 실습)
emp  테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회
not in 연산자 사용

SELECT *
FROM emp
WHERE deptno NOT IN ( 10 )
AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

where 10 실습)
emp  테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회
IN 연산자 사용

SELECT *
FROM emp
WHERE deptno IN ( 20, 30 )
AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

where 11 실습)
emp  테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

where 12 실습)
emp  테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회하세요
LIKE '78%' --> 형변환 : 명시적, 묵시적 
empno : 7800~7899
781, 78; 인 사번이 온다면 어떻게 처리할것인가? -->> 13번 문제로 

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78__';

where 13 실습)
emp  테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회하세요
LIKE 연산자 사용금지 
781, 78; 인 사번도 조회가능하게

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899;
   OR empno BETWEEN 780 AND 789;
   OR emp = 78;
   
   
연산자 우선순위
★ 일반 수학과 마찬가지로 ()를 통해 우선순위를 변경 할 수 있다.

where 14 실습)
emp  테이블에서
1. job이 SALESMAN이거나
2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원의 정보 

1번 조건 또는 2번 조건을 만족 하는 직원

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR (empno LIKE '78%' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD'));
=  OR empno LIKE '78%' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
AND가 OR보다 우선순위가 높기 때문에 굳이 ()치지 않아도 됨.

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR ((empno  empno BETWEEN 7800 AND 7899; OR empno BETWEEN 780 AND 789; OR emp = 78;
       AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD'));

SQL 작성순서            오라클에서 실행하는 순서 
1.          SELECT          3
2.          FROM            1
3.          WHERE           2
4.          ORDER BY        4

정렬
RDBMS 집합적인 사상을 따른다.
집합에는 순서가 없다. (1, 3, 5) == (3, 5, 1) ==>집합에는 순서가없기 때문에 내용만 같으면 됨
집합에는 중복이 없다. (1, 3, 5, 1) == (3, 5, 1) ==>집합에는 중복이 없기 때문에 양쪽 값이 같다.

SELECT *
FROM emp;
를 조회했을때 뜨는 순서가 항상 일정하지 않을 수 있다는 뜻. 

데이터 정렬 (ORDER BY)
ORDER BY 
ASC : 오름차순 (기본)
DESC : 내림차순

정렬방법  : ORDER BY 절을 통해 정렬 기준 칼럼을 명시 
          컬럼뒤에 [ASC | DESC] 을 기술하여 오름차순, 내림차순을 지정할 수 있다

ORDER BY (정렬기준 컬럼 or alias ON 

SELECT *
FROM emp
ORDER BY ename;

SELECT *
FROM emp
ORDER BY ename desc;

SELECT *
FROM emp
ORDER BY ename desc, mgr;
=ename 컬럼으로 내림차순 정렬후 중복값이 있다면 mgr 값으로 

별칭으로 ORDER BY 
SELECT empno, ename, sal, sal*12 salary
FROM emp
ORDER BY salary;

SELECT 절에 기술된 칼럼순서(인덱스)로 결정 ==>>오라클 실행순서 알 수 있는 부분 
SELECT empno, ename, sal, sal*12 salary
FROM emp
ORDER BY 4;

데이터 정렬 (ORDER BY 실습1)
SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc desc;

실습2
1. 상여가 있는 사람만 조회, 단 상여가 0이면 상여가 없는 것으로 간주

SELECT *
FROM emp
WHERE comm > 0
ORDER BY comm DESC, empno DESC;