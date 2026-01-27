// 1. Set Function Name: translate-and-validate

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
    // Handle CORS preflight requests
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders })
    }

    try {
        const { text, sourceLang, targetLang, note } = await req.json()

        if (!text || !targetLang) {
            throw new Error('Missing text or targetLang')
        }

        if (!GEMINI_API_KEY) {
            throw new Error('Server Config Error: GEMINI_API_KEY is missing in Secrets')
        }

        // Call Gemini API
        const prompt = `
      Translate the following text from ${sourceLang || 'auto'} to ${targetLang}.
      Also validate the content for profanity, hate speech, or sexual content.
      If the text is sexually explicit or contains severe profanity, set isValid to false.
      
      Provide the output in strict JSON format:
      {
        "translatedText": "string (the most common, generic translation)",
        "isValid": boolean, 
        "reason": "string (if invalid, explain why)",
        "disambiguationOptions": [
           "string (context 1)", 
           "string (context 2)"
        ] (list of specific contexts if the source text is ambiguous, e.g. for 'Date' -> ['Fruit', 'Calendar']. If not ambiguous, return empty list.)
      }

      Text: "${text}"
      ${note ? `Context/Meaning: "${note}" (Please translate based on this specific meaning)` : ''}
    `

        const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=${GEMINI_API_KEY}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                contents: [{ parts: [{ text: prompt }] }]
            })
        })

        const data = await response.json()

        if (!data.candidates || !data.candidates[0] || !data.candidates[0].content) {
            console.error('Gemini Error Response:', JSON.stringify(data));
            const geminiError = data.error?.message || 'Unknown AI Error';
            throw new Error(`AI Request Failed: ${geminiError}`);
        }

        const rawText = data.candidates[0].content.parts[0].text
        // Clean markdown code blocks
        const jsonString = rawText.replace(/```json\n?|\n?```/g, '').trim()

        let result;
        try {
            result = JSON.parse(jsonString)
        } catch (e) {
            throw new Error('AI returned invalid JSON format')
        }

        return new Response(JSON.stringify(result), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })

    } catch (error: any) {
        return new Response(JSON.stringify({ error: error.message || 'Unknown error' }), {
            status: 400,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
    }
})
