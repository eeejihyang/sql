DROP TABLE dept_test;

제약조건 생성방법 2번 : 
테이블 생성시 컬럼 기술 이후 별도로 제약조건을 기술하는 방법
dept_test 테이블의 deptno컬럼을 대상으로 PRIMARY KEY 제약 조건생성
CREATE TABLE dept_test( 
DEPTNO    NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,   
DNAME     VARCHAR2(14), 
LOC       VARCHAR2(13) ,
CONSTRAINT pk_dept_test PRIMARY KEY(DEPTNO)
);
dept_test 테이블에 deptno가 동일한 값을 갖는 INSERT 쿼리를 2개 생성하여
2개의 쿼리가 정상적으로 동작하는지 테스트
SELECT *
FROM dept_test

INSERT INTO dept_test VALUES (98,'DDDD','DJ');
INSERT INTO dept_test VALUES (98,'DDDD','DJ');
INSERT INTO dept_test VALUES (99,'DDDD','DJ');

NOT NULL 제약조건 : 컬럼 레벨에 기술, 테이블 기술 없음, 테이블 수정시 변경 가능 
SELECT *
FROM dept_test;
INSERT INTO dept_test VALUES (97,NULL,'DJ');
-->dname컬럼에 NOT NULL 조건 추가
CREATE TABLE dept_test( 
DEPTNO    NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,   
DNAME     VARCHAR2(14) NOT NULL, 
LOC       VARCHAR2(13) 
);
INSERT INTO dept_test VALUES (97,NULL,'DJ');
-->NULL값이 들어가는걸 방지 해달라는 제약조건을 붙혀서 NULL값이 들어가지않게 바뀜

UNIQUE 제약조건 : 해당 컬럼의 값이 다른 행에 나오지 않도록(중복되지 않도록)
                 데이터 무결성을 지켜주는 조건
                 (ex : 사번, 학번)
수업시간 UNIQUE 제약조건 명명 규칙 : UK_테이블명_해당컬럼명

DROP TABLE dept_test;

CREATE TABLE dept_test( 
DEPTNO    NUMBER(2),   
DNAME     VARCHAR2(14), 
LOC       VARCHAR2(13),
CONSTRAINT uk_dept_test_dname UNIQUE (dname, loc) 
);

/*CONSTRAINT uk_dept_test_dname UNIQUE (dname, loc) --> dname과 loc를 결합하여 중복되는 데이터가 없으면 된다는 뜻
ddit, daejeon
ddit, 대전 -->이라고 했을때 두개 컬럼의 값이 전부 똑같지 않기 때문에 dname, loc조합은 서로 다른데이터라고 보는것
ddit, daejeon
ddit, daejeon --> 제약조건으로 설정한 dname컬럼과 loc 컬럼이 모두 동일하기 때문에 중복이라고 보는것
*/

dname, loc 컬럼 조합으로 중복된 데이터가 삽입되는지 안되는지 테스트
-->dname, loc 컬럼 조합값이 동일한 데이터인경우 
INSERT INTO dept_test VALUES (90,'ddit','DJ');
INSERT INTO dept_test VALUES (90,'ddit','DJ');
/*==> 에러 (UNIQUE 제약조건에 의해)*/

ROLLBACK;

-->dname, loc 컬럼 조합값이 하나의 컬럼만 동일한 데이터인 경우 
INSERT INTO dept_test VALUES (90,'ddit','DJ');
INSERT INTO dept_test VALUES (90,'ddit','DAEJEON');
/*==>성공*/

FOREIGN KEY : 참조키
한 테이블의 컬럼 값이 참조하는 테이블의 컬럼 값중에 존재하는 값만 입력되도록 제어하는 제약조건
/*즉 FOREIGN KEY 같은 경우에는 두개의 테이블간 제약조건 --> 테스트시 2개의 테이블 필요
*참조되는 테이블의 컬럼에는 (dept_test.deptno) 인덱스가 생성되어 있어야 한다.
자세한 내용은 INDEX 배우는 시간에 다시 확인 */ 

DROP TABLE dept_test;

CREATE TABLE dept_test( 
DEPTNO    NUMBER(2),   
DNAME     VARCHAR2(14), 
LOC       VARCHAR2(13),
CONSTRAINT fk_dept_test PRIMARY KEY (deptno) 
);

테스트 데이터 준비
INSERT INTO dept_test VALUES (1, 'ddit','daejeon');

dept_test 테이블의 deptno 컬럼을 참조하는 emp_test 테이블 생성

DESC emp;

CREATE TABLE emp_test( 
empno    NUMBER(4),   
ename    VARCHAR2(10), 
deptno   NUMBER(2) REFERENCES dept_test (deptno)
);

1. dept_test 테이블에는 부서번호가 1번인 부서가 존재
2. emp_test 테이블의 deptno 컬럼으로 dept_test.deptno 컬럼을 참조
    ==> emp_test 테이블의 deptno 컬럼에는 dept_test.deptno컬럼에 존재하는 값만 
        입력하는 것이 가능 

dept_test 테이블에 존재하는 부서번호로 emp_test 테이블에 입력하는 경우
INSERT INTO emp_test VALUES(9999,'brown', 1);

dept_test테이블에 존재하지 않는 부서번호로 emp_test 테이블에 입력하는 경우 ==> 에러
INSERT INTO emp_test VALUES(9998,'sally', 2);

FK 제약조건을 테이블 컬럼 기술 이후에 별도로 기술하는 경우
>> CONSTRAINT 제약조건명 제약조건 타입 (대상컬럼) REFERENCES 참조 테이블(참조테이블의 컬럼명)
수업시간 명명규칙 : FK_타겟테이블명_참조테이블명[IDX]

DROP TABLE emp_test;

CREATE TABLE emp_test( 
empno    NUMBER(4),   
ename    VARCHAR2(10), 
deptno   NUMBER(2),
CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) 
                                 REFERENCES dept_test (deptno)
);


dept_test 테이블에 존재하는 부서번호로 emp_test 테이블에 입력하는 경우
INSERT INTO emp_test VALUES(9999,'brown', 1);

dept_test테이블에 존재하지 않는 부서번호로 emp_test 테이블에 입력하는 경우 ==> 에러
INSERT INTO emp_test VALUES(9998,'sally', 2);

참조되고 있는 부모쪽 데이터를 삭제하는 경우
dept_test 테이블에 1번 부서가 존재하고
emp_test 테이블의 brown 사원이 1번 부서에 속한 상태에서
1번 부서를 삭제하는 경우 

SELECT *
FROM emp_test

DELETE dept_test
WHERE deptno = 1;

FK의 기본설정에서는 참조하는 데이터가 없어 질 수 없기 때문에 에러발생
>>데이터를 입력하는 순서와 삭제하는 순서를 이해할 수 있음 
*CASCADE : 위에서 떨어지는데 밑의 애들이 영향을 받을때 주로 쓰는 단어(=폭포)

FK 생성시 옵션
0. DEFAULT => 무결성이 위배되는 경우 에러
1. ON DELETE CASCADE : 부모데이터를 삭제할 경우 참고있는 자식데이터를 같이 삭제
  (dept_test 테이블의 1번 부서를 삭제하면 1번 부서에 소속되어있는 brown 사원도 삭제)
2. ON DELETE SET NULL : 부모데이터를 삭제할 경우 참조하는 자식 데이터의 컬럼을 NULL로 수정

DROP TABLE emp_test;

CREATE TABLE emp_test( 
empno    NUMBER(4),   
ename    VARCHAR2(10), 
deptno   NUMBER(2),
CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno)
                                 REFERENCES dept_test (deptno) ON DELETE CASCADE
);

INSERT INTO emp_test VALUES (9999, 'BROWN', 1);
부모 데이터 삭제
DELETE dept_test
WHERE deptno = 1;
==> FOREIGN KEY 제약조건을 설정해 뒀기 때문에 이번엔 삭제가 된다.


SET NULL 옵션 확인
DROP TABLE emp_test;

CREATE TABLE emp_test( 
empno    NUMBER(4),   
ename    VARCHAR2(10), 
deptno   NUMBER(2),
CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno)
                                 REFERENCES dept_test (deptno) ON DELETE SET NULL
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO emp_test VALUES (9999, 'BROWN', 1);

부모 데이터 삭제
DELETE dept_test
WHERE deptno = 1;

SELECT *
FROM emp_test

>> deptno 값이 NULL로 대체되어있음 

CHECK 제약 조건 : 컬럼에 입력되는 값을 검증하는 제약 조건
    (EX : salary 컬럼(급여)이 음수가 입력되는것이 부자연스러움, 성별컬럼에 남,여 외에 다른값이 들어오는것 같은 잘못된 데이터를 사전방지
          직원 구분이 정직원, 임시직 2개만 존재한다고 했을 때 다른값이 들어오면 이상한 이런 상황은 무결성이 깨져 논리적으로 어긋남  )

CREATE TABLE emp_test( 
empno    NUMBER(4),   
ename    VARCHAR2(10), 
sal      NUMBER(7, 2) CONSTRAINT SAL_NO_ZERO CHECK( sal > 0 ) --> CHECK(sal IS NOT NULL)
);

sal 값이 음수인 데이터 입력
INSERT INTO emp_test VALUES (9999, 'brown', -500);
==>에러


테이블 생성 + [제약조건 포함]
: CTAS
CREATE TABLE 테이블명 AS
SELECT ....

백업
CREATE TABLE member_20200713 AS
SELECT *
FROM member;
해놓고 member 테이블에 작업 

CTAS 명령을 이용하여 EMP 테이블의 모든 데이터를 바탕으로 EMP_TEST 테이블 생성 
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp_test;

*테이블의 틀만 복사하고 싶을때 
CREATE TABLE emp_test2 AS
SELECT *
FROM emp
WHERE 1 != 1;

SELECT *
FROM emp_test2
==>테이블 컬럼 구조만 복사하고 싶을 때 WHERE절에 항상 FALSE가 되는 조건을 기술하여 생성가능 


생성된 테이블 변경 
컬럼에 작업 하는 경우를 생각해 보면
1. 존재하지 않았던 새로운 컬럼을 추가하는것이 가능 단 테이블의 컬럼 기술순서 제어 불가★
   * 신규로 추가하는 컬럼의 경우 컬럼순서가 항상 테이블의 마지막
   * 설계를 할때 컬럼순서에 충분히 고려하고 누락된 컬럼이 없는지도 고려해야함.
2. 존재하는 컬럼 삭제
   * 제약조건(FK) 주의 
3. 존재하는 컬럼 변경
   * 컬럼명 변경 ==> FK와 관계없이 알아서 적용해줌
   * 그 외적인 부분에서는 사실상 불가능 하다고 생각하면 편함
     (데이터가 이미 들어가 잇는 테이블의 경우)
     1. 컬럼 사이즈 변경
     2. 컬럼 타입 변경
   ==> 설계시 충분한 고려 
   
제약조건 작업 
1. 제약조건 추가
2. 제약조건 삭제
3. 제약조건 비활성화 / 활성화 

DROP TABLE emp_test;

테이블 수정
ALTER TABLE 테이블명 ....

1. 신규칼럼 추가

CREATE TABLE emp_test( 
empno    NUMBER(4),   
ename    VARCHAR2(10), 
deptno   NUMBER(2) 
);

ALTER TABLE emp_test ADD (hp VARCHAR2(11));

SELECT *
FROM emp_test;

DESC emp_test;

2. 컬럼 수정 (MODIFY)
** 데이터가 존재하지 않을 때는 비교적 자유롭게 수정 가능
ALTER TABLE emp_test MODIFY ( hp VARCHAR(5));
ALTER TABLE emp_test MODIFY ( hp NUMBER);
DESC EMP_TEST;

    컬럼 기본값 설정
ALTER TABLE emp_test MODIFY ( hp DEFAULT 123 );
INSERT INTO emp_test (empno, ename, deptno) VALUES (9999, 'brown', NULL);

SELECT *
FROM emp_test;

컬럼명칭 변경(RENAME COLUM 현재 컬럼명 TO 변경할 컬럼명)
ALTER TABLE emp_test RENAME COLUMN hp TO cell;

컬럼 삭제 (DROP, DROP COLUMN)
ALTER TABLE emp_test DROP (cell);
ALTER TABLE emp_test DROP COLUMN cell;

DESC emp_test;

3. 제약조건 추가 , 삭제 ( ADD, DROP)
            +
   테이블레벨의 제약조건 생성 
   
ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건 타입 대상컬럼;

별도의 제약조건 없이 emp_test 테이블 생성

DROP TABLE emp_test;

CREATE TABLE emp_test( 
empno    NUMBER(4),   
ename    VARCHAR2(10), 
deptno   NUMBER(2) 
);

테이블 수정을 통해서 emp_test 테이블의 empno 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

제약조건 삭제 (DROP)
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

제약조건 활성화 비활성화
제약조건 DROP은 제약조건 자체를 삭제하는 행위
제약조건 비활성화는 제약조건 자체는 남겨두지만, 사용하지는 않는 형태
때가되면 다시 활성화 하여 데이터 무결성에 대한 부분을 강제할 수 있음

DROP TABLE emp_test;

CREATE TABLE emp_test( 
empno    NUMBER(4),   
ename    VARCHAR2(10), 
deptno   NUMBER(2) 
);

테이블 수정 명령을 통해 emp_test 테이블의 emp_no 컬럼으로 PRIMARY KEY 제약 생성
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

제약조건을 활성화 / 비활성화 (ENABLE / DISABLE)
ALTER TABLE emp_test DISABLE CONSTRAINT pk_emp_test;
pk_emp_test 가 비활성화 되어있기 때문에 empno 컬럼에 중복되는 값 입력이 가능

INSERT INTO emp_test VALUES (9999, 'brown', NULL);
INSERT INTO emp_test VALUES (9999, 'sally', NULL);

pk_emp_test 제약조건을 활성화
ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test;
==> 제약조건을 활성화 시키면 위에 만들어논 컬럼과 제약조건이 맞지 않아서
    수정후 활성화 가능
    
DICTIONARY
SELECT *
FROM user_tables;

SELECT *
FROM user_constraints;

SELECT *
FROM user_constraints
/*WHERE table_name = 'EMP_TEST';*/
WHERE constraint_type = 'P';

SELECT *
FROM user_cons_columns
WHERE TABLE_NAME = 'CYCLE' 
AND constraint_name = 'PK_CYCLE';

SELECT *
FROM user_tab_comments;

SELECT *
FROM user_col_comments;

테이블 , 컬럼 주석달기
COMMENT ON TABLE 테이블명 IS '주석'
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';

emp_test 테이블, 컬럼에 주석;
COMMENT ON TABLE emp_test IS '사원_복제';
COMMENT ON COLUMN emp_test.empno IS '사번';
COMMENT ON COLUMN emp_test.ename IS '사원이름';
COMMENT ON COLUMN emp_test.deptno IS '부서번호';

SELECT *
FROM user_tab_comments;

SELECT *
FROM user_col_comments
WHERE table_name = 'EMP_TEST';

SELECT *
FROM user_col_comments

SELECT user_tab_comments.TABLE_NAME, user_tab_comments.TABLE_TYPE,TAB_COMMENT,USER_COL_COMMENTS.COLUMN_NAME,COL_COMMENT
FROM user_col_comments,user_tab_comments
WHERE user_tab_comments.comments = user_col_comments.comments

선생님 풀이 comment 1_

SELECT *
FROM user_tab_comments;

SELECT *
FROM user_col_comments




▼
SELECT*
FROM user_col_comments t,user_tab_comments c;
WHERE

▼
SELECT t.*, c.column_name, c.comments
FROM user_col_comments c,user_tab_comments t
WHERE t.table_name = c.table_name
AND t.table_name IN ('CYCLE', 'CUSTOMER','DAILY','PRODUCT');


ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno)
ALTER TABLE emp ADD CONSTRAINT FK_emp FOREIGN KEY (deptno) 
                                      REFERENCES dept (deptno)
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno)
