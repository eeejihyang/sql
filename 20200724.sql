계층쿼리
1. CONNECT BY LEVEL <, <= 정수
    : 시작행, 연결될 다음 행과의 조건이 없음
      ==> CROSS JOIN과 유사
2. START WITH, CONNECT BY : 일반적인 계층 쿼리
                            시작 행 지칭, 연결될 다음 행과의 조건을 기술 
                            
CREATE TABLE imsi(
    t VARCHAR2(2)
);

INSERT INTO imsi VALUES ('a');
INSERT INTO imsi VALUES ('b');
COMMIT;  -->트랜잭션을 확정하는 커밋

LEVEL : 1 --> LEVEL 시작
SELECT *
FROM imsi
CONNECT BY LEVEL <=1; -->결과 2행 

SELECT *
FROM imsi
CONNECT BY LEVEL <=2; -->결과 6행

SELECT *
FROM imsi
CONNECT BY LEVEL <=3; -->결과 14행

SELECT t, LEVEL, LTRIM(SYS_CONNECT_BY_PATH(t,'-'),'-')
FROM imsi
CONNECT BY LEVEL <=3;

SELECT *
FROM dual
CONNECT BY LEVEL <=10;

SELECT DUMMY, LEVEL
FROM dual
CONNECT BY LEVEL <=10;


―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
LAG(col) : 파티션별 이전행의 특정행의 특정 컬럼 값을 가져오는 함수
LEAD(col) : 파티션별 이후 행의 특정 컬럼값을 가져오는 함수

자신보다 전체사원의 급여순위가 1단계 낮은사람의 급여값을 5로째로컬럼으로 생성
(단, 급여가 같을경우 입사일자가 빠른사람이 우선순위가 높다
SELECT empno, ename, hiredate,sal
FROM emp 
ORDER BY sal DESC, hifrdate;

WHERE절 기술안하면 모든행에 적용 -->
분석함수 실습 5번)
SELECT empno, ename, hiredate, sal, LEAD(sal) OVER(ORDER BY sal DESC, hiredate)lead_sal
FROM emp;

SELECT empno, ename, hiredate, sal, LAG(sal) OVER(ORDER BY sal DESC, hiredate)lag_sal
FROM emp;



분석함수 실습 6번)
윈도우함수를 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군(JOB),급여 정보와 
담당업무별 급여순위가 1단계 높은 사람의 급여를 조회하는 쿼리. 

SELECT empno,ename,hiredate, job, sal, LAG(sal) OVER(PARTITION BY job ORDER BY sal)lag_sal
FROM emp


ANA5_1] -->컬럼에대한 확장 -->join -->다른테이블에 있는 데이터가 아니기때문에 셀프조인 

SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate

▽번호를 붙혀줘서 1일때 2랑 
SELECT a.empno,a.ename,a.hiredate,a.sal,b.sal LAG_SAL
FROM
(SELECT ROWNUM rn,a.*
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate)a)a,
(SELECT ROWNUM rn,b.*
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate)b)b
WHERE a.rn - 1 = b.rn (+) 
ORDER BY a.sal DESC, a.hiredate



WINDOWING : 파티션 내의 행들을 세부적으로 선별하는 범위를 기술
UNBOUND PRECEDING : 현재 행을 기준으로 선행(이전에 위치)하는 모든 행들
CURRENT ROW : 현재 행
UNBOUND FOLLOWING : 현재 행을 기준으로 이후 모든 행

SELECT empno, ename, sal
FROM emp
ORDER BY sal;

//누적합계구하기 p.125
SELECT empno, ename, sal ,
        SUM(sal) OVER ( ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp

SELECT empno, ename, sal ,
        SUM(sal) OVER ( ORDER BY sal ) c_sum
FROM emp

--> 위아래 값이 좀 비슷하지만 좀 다름 -->WINDOWING 기본 설정값이 존재하기 때문

WINDOWING 기본 설정값 : 

SELECT empno, ename, sal ,
      /*SUM(sal) OVER ( ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum,*/
        SUM(sal) OVER ( ORDER BY sal ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum2
FROM emp

ana7]

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno
            RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp


WINDOWING 기본 설정값 : 조건을 기술하지 않으면 RANGE UNBOUNDED PRECEDING
                                           RANGE UNBOUNDED PRECEDING AND CURRENT ROW  
                       
                       
                       ROW | RANGE 상황에 따라 맞게 사용하고 자기가 제어하기 편한걸 골라서 쓰면됨
                       
모델링 과정(요구사항 파악 이후)
[개념모델] - ==> (논리모델 - 물리모델) 
논리모델의 요약판 

논리 모델 : 시스템에서 필요로 하는 엔터티(테이블), 엔터티의 속성, 엔터티간의 관계를 기술
           데이터가 어떻게 저장될지는 관심사항이 아님 ==> 물리 모델에서 고려할 사항
           논리 모델에서는 데이터의 전반적인 큰 틀을 설계한다.

물리 모델 : 논리 모델을 갖고 해당시스템이 사용할 데이터 베이스를 고려하여 최적화된 테이블, 컬럼, 제약조건을 설계하는 단계

사용하는 용어차이 ▼
논리모델        :        물리 모델
엔터티(entity)type        테이블
속성(attribute)            컬럼
식별자                      키      ==> 행들을 구분할 수 있는 유일한 값 ex)empno
관계(relation)            제약조건
관계 차수 : 1-N, 1-1, N-N ==> 1:N으로 변경할 대상
           ==> 수직바, 까마귀발로 표기
관계 옵션 : mandatory(필수), optional(옵션) ==> ○로 표기
    

★요구사항( 요구사항 기술서, 장표, 인터뷰)에서 명사를 보면 그 명사가 ==>엔터티 or 속성일 확률이 높다.

명명규칙
엔터티 : 단수 명사, 
        서술식 표현은 잘못된 표현. 복수명사도 X