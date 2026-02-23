import os
import json

def fix_l10n():
    l10n_dir = 'lib/l10n'
    # Base values from EN
    default_values = {
        'helpModeChatDesc': 'Practice real-world conversations by chatting with an AI persona.',
        'helpModeChatDetails': '• Start Chat: Tap bubble icon on top right\n• Choose Persona: Pick teacher, guide or friend\n• Chat & Save: AI responses are auto-translated. Tap any message to save it to Mode 2\n• Dual Language: View both mother tongue and target language for all messages\n• TTS: Tap speaker icon to hear pronunciation for both languages\n• Auto-Title: AI suggests a title based on topic\n• Management: View past chats in history',
        'noDialogueHistory': 'No dialogue history.',
        'chatNewChat': 'New Chat',
        'chatChoosePersona': 'Choose a Persona',
        'chatTypeHint': 'Type a message...',
        'chatFailed': 'Chat failed: {error}',
        'chatNoConversations': 'No conversations yet',
        'chatStartNewPrompt': 'Start a new chat to practice!',
        'chatFromConversation': 'From Conversation ({speaker})',
        'personaTeacher': 'English Teacher',
        'personaGuide': 'Travel Guide',
        'personaFriend': 'Local Friend',
        'chatUntitled': 'Untitled Conversation',
        'chatAiChat': 'Chat',
        'manageParticipants': 'Manage Participants',
        'tutorialAiChatTitle': 'AI Chat',
        'tutorialAiChatDesc': 'Practice real conversation with AI personas here.',
        'chatEndTitle': 'End & Save Chat',
        'chatEndMessage': 'Do you want to end this conversation? You can set a title for it.',
        'chatSaveAndExit': 'Save & Exit'
    }

    for filename in os.listdir(l10n_dir):
        if filename.endswith('.arb'):
            filepath = os.path.join(l10n_dir, filename)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                
                updated = False
                for key, val in default_values.items():
                    if key not in data:
                        data[key] = val
                        updated = True
                
                if updated:
                    # Sort keys to keep them consistent if needed, or just append
                    with open(filepath, 'w', encoding='utf-8') as f:
                        json.dump(data, f, ensure_ascii=False, indent=2)
                    print(f"✅ Updated {filename}")
            except Exception as e:
                print(f"Error processing {filename}: {e}")

if __name__ == "__main__":
    fix_l10n()
