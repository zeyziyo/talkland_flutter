# Talkie Core Design Strategy (핵심 설계 원칙)

본 문서는 Talkie 프로젝트의 핵심 설계 원칙과 아키텍처 결정을 기록하여, 에이전트의 작업 일관성을 유지하기 위해 작성되었습니다. 모든 작업 시 이 원칙을 최우선으로 준수해야 합니다.

## 1. Native Tag Strategy (현지어 태그 전략)
온라인 자료실(Online Library)에서 자료를 가져올 때, 각 언어별 자료의 제목은 해당 언어(Native)로 유지하면서도 시스템적으로는 하나의 그룹으로 연결되어야 합니다.

- **원칙**: JSON 파일 내의 `meta['title']` (예: "기본 인사")은 **아이템의 태그(Tag)**로 저장합니다. 
- **용도**: Mode 2(복습) 및 Mode 3(발음 연습)의 필터 UI에서는 이 원어 태그를 기준으로 자료를 분류하고 노출합니다.
- **이점**: 사용자가 자신의 모국어로 된 제목을 보며 학습 자료를 선택할 수 있습니다.

## 2. Smart Sync (Pivot Strategy - 파일 이름 기준 동기화)
서로 다른 언어 버전(한국어-영어, 스페인어-영어 등)의 자료가 데이터베이스 상에서 하나의 `group_id`로 묶여야 소스-타겟 페어링이 가능합니다.

- **원칙**: 온라인 자료실의 **파일 이름**(`fileName`, 예: `nouns_1`)을 **동기화용 키(Sync Pivot)**로 사용합니다.
- **작동 방식**:
    - 자료 Import 시 파일명(확장자 제외)을 `overrideSubject`로 전달합니다.
    - `DatabaseService.saveUnifiedRecord`는 이 파일명이 동일한 경우, 기존에 생성된 `group_id`를 찾아 재사용(Smart Sync)합니다.
- **이점**: 영문 원제(Subject)는 디자인 목적상 바뀔 수 있지만, 파일 이름은 URL 경로이므로 불변성이 훨씬 높습니다.
- **주의**: 이 동기화용 키와 별개로 UI용 태그는 반드시 위 1번의 Native 명칭을 사용해야 합니다.

## 3. UI/UX Principles (UI 설계 원칙)
사용자의 명시적 허락 없이 UI 구조를 변경하거나 복잡하게 만들지 않습니다.

- **Header Rule**: Mode 2, Mode 3의 상단(검색란 위)에는 임의의 헤더나 버튼을 추가하지 않습니다. (사용자 제거 요청 사항)
- **Menu Centralization**: '온라인 자료실'과 같은 주요 부가 기능은 메인 화면(`HomeScreen`)의 AppBar 메뉴(PopupMenu)를 통해 접근합니다.
- **Search & Filter**: 
    - Mode 2, Mode 3는 `SearchFilterDialog`를 통해 태그(자료집), 개수 제한, 시작 문자 필터링을 제공합니다.
    - "상세 분류" 드롭다운이나 튠 버튼을 본문에 상시 노출하지 않고, 필터링이 필요할 때만 다이얼로그를 통해 진입합니다.

## 4. Database & Synchronization (데이터베이스 및 동기화)
- **Unified Schema**: 모든 단어와 문장은 `words`, `sentences` 테이블에 저장되며, 각각 `group_id`를 통해 언어별 버전이 연결됩니다.
- **Multi-Language Support**: 현재 80개 언어를 지원하며, 문자열 추가 시 모든 언어의 `.arb` 파일을 동기화해야 합니다.
- **Local Priority**: 당분간 로컬 빌드는 수행하지 않으며, 코드의 무결성과 설계 일관성을 유지하는 데 집중합니다.

---
최종 업데이트: 2026-02-09
작성자: Antigravity (Agent)
승인 여부: 사용자 지시 반영됨
