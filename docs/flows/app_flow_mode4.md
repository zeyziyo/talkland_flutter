# 앱 흐름도: 대화 모드 (Mode 4 Flow)

> [!NOTE]
> 본 문서는 Mode 4(자유 대화 화면)의 UI 요소와 실제 코드 로직을 연결합니다. 번호가 달린 링크(예: `[1]`)를 클릭하면 별도로 분리된 **[로직 통합 명세(Logic Reference)](./logic_reference.md)**로 이동합니다.

<div style="background-color: #f3e5f5; padding: 30px; border-radius: 16px; border: 1px solid #ce93d8; font-family: sans-serif;">
  <h2 style="color: #6a1b9a; margin-top: 0; display: flex; align-items: center;">
    <span style="background: #6a1b9a; color: white; padding: 5px 12px; border-radius: 8px; margin-right: 12px;">4</span> 
    Mode 4 (자유 대화/채팅 화면)
  </h2>

  <!-- 상단 앱바 제어부 -->
  <div style="background: #4a69bd; padding: 10px 15px; border-radius: 12px; margin-bottom: 15px; display: flex; align-items: center; color: white; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
    
    <!-- 타이틀 영역 -->
    <div style="flex: 1; display: flex; flex-direction: column;">
      <div style="display: flex; align-items: center;">
        <span style="color: #69f0ae; margin-right: 8px; font-size: 18px;">✅</span> 
        <span style="font-size: 18px; font-weight: bold;">New Conversation</span>
      </div>
      <!-- 파트너 모드 시 노출 -->
      <span style="font-size: 12px; color: rgba(255,255,255,0.7); margin-left: 26px;">파트너 모드: 수동</span>
    </div>
    
    <!-- 우측 액션 아이콘들 -->
    <div style="display: flex; gap: 8px;">
        <span style="padding: 8px; background: rgba(255,255,255,0.1); border-radius: 8px; cursor: pointer;">🔍</span>
        <span style="padding: 8px; background: rgba(255,255,255,0.1); border-radius: 8px; cursor: pointer;" title="모드 전환">🤖 <a href="./logic_reference.md#LC-PARTNER-MODE" style="text-decoration: none; font-size: 11px; vertical-align: super; color: white;">[24]</a></span>
        <span style="padding: 8px; background: rgba(255,255,255,0.1); border-radius: 8px; cursor: pointer;" title="저장">💾 <a href="./logic_reference.md#LC-CHAT-SAVE" style="text-decoration: none; font-size: 11px; vertical-align: super; color: white;">[25]</a></span>
    </div>
  </div>

  <!-- 메세지 리스트 -->
  <div style="background: #fafafa; padding: 20px; border-radius: 12px; border: 1px solid #e0e0e0; min-height: 400px; display: flex; flex-direction: column; gap: 15px; position: relative;">
    
    <!-- 상대방(AI/Partner) 버블 (왼쪽 정렬) -->
    <div style="align-self: flex-start; max-width: 85%;">
        <!-- 스피커 헤더 -->
        <div style="display: flex; align-items: flex-end; gap: 6px; margin-bottom: 4px;">
            <div style="background: #e0f2f1; color: #00796b; padding: 2px 6px; border-radius: 4px; font-size: 10px; font-weight: bold;">AI</div>
            <span style="color: #616161; font-size: 12px; font-weight: bold;">Assistant</span>
            <span style="cursor: pointer; opacity: 0.6;">🔊 <a href="./logic_reference.md#LC-AI-TTS" style="text-decoration: none; font-size: 10px; vertical-align: super;">[26]</a></span>
        </div>
        <!-- 메시지 바디: _showTranslationMap 토글 에 따라 원문 ↔ 번역문 동적 전환 -->
        <div style="display: flex; align-items: flex-end; gap: 4px;">
            <div style="background: #f5f5f5; padding: 12px 16px; border-radius: 16px; border-top-left-radius: 4px; color: #212121; font-size: 16px; border: 1px solid #eeeeee;">
                Hello! How can I help you?
            </div>
            <!-- 번역 뱃지 (번역 활성 시 토글됨) -->
            <span style="font-size: 18px; cursor: pointer;">🌐 <a href="./logic_reference.md#LC-CHAT-TRANSLATE" style="text-decoration: none; font-size: 10px; vertical-align: super;">[27]</a></span>
        </div>
    </div>

    <!-- 유저 입력 버블 (오른쪽 정렬) -->
    <div style="align-self: flex-end; max-width: 85%;">
        <!-- User 에서는 듣기 아이콘이 왼쪽에 표시됨 -->
        <div style="display: flex; align-items: flex-end; justify-content: flex-end; gap: 6px; margin-bottom: 4px;">
            <span style="cursor: pointer; opacity: 0.6;">🔊</span>
            <span style="color: #616161; font-size: 12px; font-weight: bold;">나 (User)</span>
            <div style="background: #e3f2fd; color: #1565c0; padding: 2px 6px; border-radius: 4px; font-size: 10px; font-weight: bold;">ME</div>
        </div>
        <div style="display: flex; align-items: flex-end; flex-direction: row-reverse; gap: 4px;">
            <div style="background: #e3f2fd; padding: 12px 16px; border-radius: 16px; border-top-right-radius: 4px; color: #1565c0; font-size: 16px;">
                만나서 반가워!
            </div>
            <!-- User 버블 번역 토글 뱃지 -->
            <span style="font-size: 18px; cursor: pointer;">🌐</span>
        </div>
    </div>
    
  </div>

  <!-- 하단 입력부 영역 -->
  <div style="background: white; margin-top: -10px; padding: 10px 15px; border-radius: 0 0 12px 12px; border: 1px solid #e0e0e0; border-top: none; box-shadow: 0 -2px 4px rgba(0,0,0,0.02);">
    <div style="display: flex; align-items: center; gap: 10px;">
        <!-- 목표 언어 뱃지 또는 Partner Label -->
        <span style="font-size: 12px; font-weight: bold; color: #1976d2; background: #e3f2fd; padding: 4px 8px; border-radius: 12px;">EN</span>
        
        <!-- 텍스트 입력 칸 -->
        <div style="flex: 1; border: 1px solid #dce1e9; padding: 10px 14px; border-radius: 20px; color: #9e9e9e; font-size: 14px; background: #fafafa;">
        Type message... (키보드 팝업 영역)
        </div>

        <!-- 마이크 버튼 (좌측이 아닌 우측 텍스트창 바로 옆!) -->
        <div style="padding: 8px; cursor: pointer; color: #2196f3;" title="음성 인식 시작">
        🎤 <a href="./logic_reference.md#LC-CHAT-MIC" style="text-decoration: none; font-size: 10px; vertical-align: super;">[29]</a>
        </div>
        
        <!-- 전송 버튼 -->
        <div style="padding: 8px; cursor: pointer; color: #1e88e5;" title="메시지 전송">
        ➤ <a href="./logic_reference.md#LC-CHAT-PROCESS" style="text-decoration: none; font-size: 10px; vertical-align: super;">[28]</a>
        </div>
    </div>
  </div>

</div>

---

## 🔗 참고 문서
- [로직 통합 명세 (Logic Reference)](./logic_reference.md)
- [메인 화면 흐름도 (App Flow Main)](./app_flow_main.md)
- [복습/말하기 화면 (App Flow Mode 2 & 3)](./app_flow_mode2.md)
