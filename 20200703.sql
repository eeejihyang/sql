join 실습1)

SELECT LPROD_GU,lprod_nm,prod_id,prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

ANSI-SQL 두테이블의 연결 컬럼명이 다르기 때문에 NATURAL JOIN , JOIN with USING은 사용불가

SELECT LPROD_GU,lprod_nm,prod_id,prod_name
FROM prod JOIN lprod ON (prod.prod_lgu = lprod.lprod_gu);

join 실습2)

SELECT buyer_id,buyer_name,prod_id,prod_name
FROM buyer,prod
WHERE prod.prod_buyer = buyer.buyer_id;

SELECT buyer_id,buyer_name,prod_id,prod_name
FROM buyer JOIN prod ON (prod.prod_buyer = buyer.buyer_id);

join 실습3)
SELECT mem_id,mem_name,prod_id,prod_name,cart_qty
FROM member,cart,prod
WHERE member.mem_id = cart.cart_member
  AND cart.cart_prod = prod.prod_id;
  
ANSI-SQL
SELECT mem_id,mem_name,prod_id,prod_name,cart_qty
FROM member JOIN cart ON ( member.mem_id = cart.cart_member )
            JOIN prod ON (  cart.cart_prod = prod.prod_id );

CUSTOMER : 고객
PRODUCT : 제품
CYCLE : 고객 제품 애음 주기

SELECT *
FROM cycle;

join 실습4)

SELECT customer.cid,customer.cnm,cycle.pid,cycle.day,cycle.cnt
FROM customer,cycle
WHERE customer.cid = cycle.cid
 AND cnm IN('brown', 'sally');
-->customer.*, = customer.cid,customer.cnm,pid,day,cnt
-->AND customer.cnm IN ('brown', 'sally');
join 실습5)

SELECT customer.*,cycle.pid,day,cnt
FROM customer,cycle,product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
  AND customer.cnm IN('brown', 'sally');

join 실습6)

SELECT customer.*,cycle.pid,pnm, SUM(cnt)
FROM customer,cycle,product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
GROUP BY customer.cid,customer.cnm,cycle.pid,pnm;

(SELECT cid, pid, SUM(cnt)
FROM cycle
GROUP BY cid, pid ) cycle, customer, product;

join 실습7)

SELECT cycle.pid,product.pnm,cycle.cnt
FROM cycle,product
WHERE cycle.pid = product.pid;

SELECT cycle.pid,pnm, SUM(cnt)
FROM cycle,product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid,pnm;

실습 8~13번 주말 과제

조인 성공여부로 데이터 조회를 결정하는 구분방법
INNER JOIN : 조인에 성공하는 데이터만 조회하는 조인 방법
OUTER JOIN : 조인에 실패 하더라도, 개발자가 지정한 기준이 되는 
             테이블의 데이터는 나오도록 하는 조인
OUTER JOIN <======> INNER JOIN

복습 - 사원의 관리자 이름을 알고 싶은 상황
    조회 컬럼 : 사원의 사번, 사원의 이름, 사원의 관리자의 사번 ,사원의 관리자의 이름
동일한 테이블끼리 조인 되었기 때문에 :SELF-JOIN
조인조건을 만족하는 테이터만 조회 되었기 때문에 : INNER-JOIN
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno;

KING 의 경우 persident이기 때문에 MGR 컬럼의값이 NULL ==> 조인에 실패
==> KING의 데이터는 조회되지 않음 (총 14건 중 13건반 조인성공)

OUTER 조인을 이용하여 조인테이블에 기준이 되는 테이블을 선택하면
     실패하더라도 기준 테이블의 데이터는 조회 되도록 할 수 있다.

LEFR / RIGHT OUTER

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, LEFT OUTER JOIN emp m ON (e.mgr = m.empno);


WHERE e.mgr = m.empno;