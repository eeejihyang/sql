실행계획
개발자가 SQL을 dbms에 요청을 하더라도
1. 오라클 서버가 항상 최적의 실행계획을 선택한다는 보장 없음 
   └(응답성이 중요하기 때문에 : OLTP - Online Tranjaction Processing의 약자
      전체 처리 시간이 중요   : OLAP - Online Analytical Processing)
                             ex : 은행이자 ==> 실행계획 세울 때 30분이상 소요되기도 함.
2. 항상 실행계획을 세우지 않음
    만약 동일한 SQL이 이미 실행된적이 있으면 해당 SQL의 실행계획을 새롭게 세우지 않고 
    Shared pool(메모리)에 존재하는 실행계획을 재사용 

    동일한 SQL : 문자가 완벽하게 동일한 SQL을 의미하며 SQL의 실행결과가 같다고 동일한 SQL로 보지않는다.
                문자가 완벽하게 ==> 대소문자를 가리고, 공백도 문자로 취급
    EX : SELECT * FROM emp ;
         select * FROM emp ; 두개의 sql은 서로 다른 sql로 인식.
         
SELECT /* plan_test */ *
FROM emp
WHERE empno = 7698;

select /* plan_test */ *
FROM emp
WHERE empno = 7369;

--> 문자가 다르기 때문에 각각 다른 SQL로 인식 이러한 이유로 바인드 변수를 사용한다

select /* plan_test */ *
FROM emp
WHERE empno = :empno;

DCL : Data Control Language - 시스템 권한 또는 객체 권한을 부여 / 회수
부여 
GRANT권한명 | 롤명 TO 사용자;

회수
REVOKE 권한명 | 롤명 FROM 사용자;


DATA DICTIONARY
오라클 서버가 사용자 정보를 관리하기 위해 저장한 데이터를 볼 수 있는 view
CATEGORY(접두어)
USER_: 해당 사용자가 소유한 객체조회
ALL _: 해당 사용자가 소유한 객체 + 권한을 부여받은 객체 조회
DBA_: 데이터베이스에 설치된 모든 객체 (DBA 권한이 있는 사용자만 가능 -SYSTEM)
v$ : 성능, 모니터와 관련된 특수 view


