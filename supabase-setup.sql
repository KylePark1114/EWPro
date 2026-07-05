-- ════════════════════════════════════════════════════════════
--  EW PRO · Supabase 초기 설정 SQL
--  Supabase 대시보드 → SQL Editor 에 통째로 붙여넣고 RUN 하세요.
-- ════════════════════════════════════════════════════════════

-- 1) 문의 테이블 생성 ------------------------------------------------
create table if not exists public.inquiries (
  id            uuid primary key default gen_random_uuid(),
  created_at    timestamptz not null default now(),
  company       text,
  contact_name  text,
  phone         text,
  email         text,
  inquiry_type  text,          -- 표준 견적 / 커스텀 견적 / 대량 OEM / 기타 문의
  message       text,
  status        text not null default 'new'   -- new / replied / done
);

-- 2) 행 수준 보안(RLS) 켜기 -----------------------------------------
alter table public.inquiries enable row level security;

-- 3) 정책: 누구나 "제출(INSERT)"만 가능, 읽기/수정은 불가 ----------
--    → 방문자는 문의를 넣을 수만 있고, 남의 문의를 볼 수는 없습니다.
--    → 접수된 문의 열람은 Supabase 대시보드(Table Editor) 또는
--       로그인한 관리자 페이지에서만 하게 됩니다.
drop policy if exists "anyone can insert inquiries" on public.inquiries;
create policy "anyone can insert inquiries"
  on public.inquiries
  for insert
  to anon
  with check (true);

-- (선택) 4) 로그인한 관리자만 전체 조회 가능하게 하려면 아래 주석 해제
-- drop policy if exists "authenticated can read inquiries" on public.inquiries;
-- create policy "authenticated can read inquiries"
--   on public.inquiries
--   for select
--   to authenticated
--   using (true);

-- 끝. 이제 사이트의 문의 폼이 이 테이블에 저장됩니다.
