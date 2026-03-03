# 앱 흐름도: 학습 자료 및 복습 모드 (Mode 2 Flow)

> [!NOTE]
> 본 문서는 Mode 2(복습 화면)의 UI 요소와 실제 코드 로직을 연결합니다. 번호가 달린 링크(예: `[1]`)를 클릭하면 별도로 분리된 **[로직 통합 명세(Logic Reference)](./logic_reference.md)**로 이동합니다.

<div style="background-color: #f8faff; padding: 30px; border-radius: 16px; border: 1px solid #e1e8f5; font-family: sans-serif;">
  <h2 style="color: #1a73e8; margin-top: 0; display: flex; align-items: center;">
    <span style="background: #1a73e8; color: white; padding: 5px 12px; border-radius: 8px; margin-right: 12px;">2</span> 
    Mode 2 (복습 화면)
  </h2>

  <!-- 공통 상단 앱바 (Home Screen) -->
  <div style="background: #4a69bd; padding: 15px 20px; border-radius: 12px; margin-bottom: 25px; display: flex; align-items: center; color: white;">
    <div style="background: rgba(255,255,255,0.2); padding: 5px; border-radius: 8px; display: flex;">
      <span style="background: white; color: #4a69bd; padding: 5px 15px; border-radius: 6px; font-weight: bold; font-size: 13px;">단어 (Word)</span>
      <span style="padding: 5px 15px; font-size: 13px;">문장 (Sentence)</span> <a href="./logic_reference.md#LC-TOGGLE" style="text-decoration: none; font-size: 11px; vertical-align: super; color: white;">[1]</a>
    </div>
    
    <div style="margin-left: 10px; cursor: pointer; background: rgba(0,0,0,0.2); padding: 5px; border-radius: 5px;" title="언어 스왑">
      🔄 <a href="./logic_reference.md#LC-SWAP-LANG" style="text-decoration: none; font-size: 11px; vertical-align: super; color: white;">[2]</a>
    </div>

    <!-- Mode 2 & 3 전용 자료집 선택 -->
    <div style="margin-left: auto; background: #fff9c4; color: #856404; padding: 6px 12px; border-radius: 20px; font-size: 13px; font-weight: bold; border: 1px solid #ffe082;">
      📚 나의 단어장 (선택) ▼ <a href="./logic_reference.md#LC-SUBJECT-PICK" style="text-decoration: none; font-size: 11px; vertical-align: super; color: #856404;">[10]</a>
    </div>
  </div>

  <!-- 스마트 검색바 -->
  <div style="background: white; padding: 12px 16px; border-radius: 25px; border: 1px solid #e1e8f5; margin-bottom: 15px; display: flex; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
    <span style="font-size: 18px; margin-right: 10px; color: #9e9e9e;">🔍</span>
    <span style="color: #9e9e9e; font-style: italic; font-size: 14px;">단어 검색... (자동 완성 지원)</span> <a href="./logic_reference.md#LC-SEARCHBAR" style="text-decoration: none; font-size: 12px; vertical-align: super; margin-left: auto;">[15]</a>
  </div>

  <!-- 액션 라인 -->
  <div style="display: flex; gap: 8px; margin-bottom: 20px; align-items: center; overflow-x: auto; padding-bottom: 5px;">
    <div style="background: #f8f9fa; padding: 8px 12px; border-radius: 8px; border: 1px solid #dce1e9; font-size: 12px; white-space: nowrap; font-weight: bold; color: #424242;">
      🎛️ 검색 조건 (0) <a href="./logic_reference.md#LC-SEARCH-FILTER" style="text-decoration: none; font-size: 11px; vertical-align: super;">[16]</a>
    </div>
    <div style="background: #e8f5e9; padding: 8px 12px; border-radius: 8px; border: 1px solid #c8e6c9; font-size: 12px; white-space: nowrap; color: #2e7d32; font-weight: bold;">
      👁️ 외운 항목 보기 <a href="./logic_reference.md#LC-TOGGLE-MEMORIZED" style="text-decoration: none; font-size: 11px; vertical-align: super;">[17]</a>
    </div>
    <div style="background: #f8f9fa; padding: 8px 12px; border-radius: 8px; border: 1px solid #dce1e9; font-size: 12px; white-space: nowrap; color: #1565c0; font-weight: bold;">
      ▶ 자동 재생 <a href="./logic_reference.md#LC-AUTOPLAY" style="text-decoration: none; font-size: 11px; vertical-align: super;">[18]</a>
    </div>
    <div style="background: #f8f9fa; padding: 8px 12px; border-radius: 8px; border: 1px solid #dce1e9; font-size: 12px; white-space: nowrap; color: #616161; font-weight: bold;">
      ⏱️ 대기 시간: 2s <a href="./logic_reference.md#LC-THINKING-TIME" style="text-decoration: none; font-size: 11px; vertical-align: super;">[19]</a>
    </div>
  </div>

  <!-- 리스트 정보 (Progress Bar) -->
  <div style="display: flex; justify-content: space-between; margin-bottom: 15px; color: #424242; font-size: 14px; font-weight: bold; padding: 0 16px;">
    <span>📊 학습 현황: 5 / 20</span>
    <span style="color: #9e9e9e;">25%</span>
  </div>

  <!-- 카드 리스트 (Mode2Card) -->
  <div style="background: #f1f5f9; padding: 15px; border-radius: 10px; border: 1px solid #dce1e9; min-height: 200px;">
    
    <!-- 아이템 카드 (최상위 노출 언어는 언어 스왑 상태에 따라 다름) -->
    <div style="background: white; padding: 15px; border-radius: 12px; margin-bottom: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border: 2px solid transparent;">
        <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
            <div style="display: flex; gap: 6px; align-items: center;">
                <span style="background: #e3f2fd; color: #1565c0; padding: 2px 6px; border-radius: 4px; font-size: 10px; font-weight: bold;">EN</span>
                <span style="background: #e8eaf6; color: #3f51b5; padding: 2px 6px; border-radius: 4px; font-size: 10px;">명사</span>
            </div>
            <!-- 암기 완료 체크박스 -->
            <span style="font-size: 22px; color: #4caf50;">✅</span> <a href="./logic_reference.md#LC-MARK-MEMORIZED" style="text-decoration: none; font-size: 11px; vertical-align: super;">[20]</a>
        </div>
        
        <div style="font-size: 22px; font-weight: bold; margin-bottom: 10px; color: #212121;">Apple</div>
        
        <!-- 카드 확장 시 (클릭 시 나타남) -->
        <div style="border-top: 1px dashed #e2e8f0; padding-top: 12px; display: flex; flex-direction: column; gap: 8px;">
            <div style="display: flex; align-items: center; gap: 6px;">
                <span style="background: #fce4ec; color: #c2185b; padding: 2px 6px; border-radius: 4px; font-size: 10px; font-weight: bold;">KO</span>
                <span style="font-size: 12px; color: #757575;">(과일/디저트 태그)</span>
            </div>
            <div style="font-size: 16px; color: #424242; font-weight: bold;">사과</div>
        </div>
    </div>
  </div>
</div>

---
## 🔗 참고 문서
- [로직 통합 명세 (Logic Reference)](./logic_reference.md)
- [메인 화면 흐름도 (App Flow Main)](./app_flow_main.md)
