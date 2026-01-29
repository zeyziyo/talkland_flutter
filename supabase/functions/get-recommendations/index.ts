// @ts-nocheck
const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders })
    }

    try {
        const { history, sourceLang, targetLang } = await req.json()

        if (!targetLang) {
            throw new Error('Missing targetLang')
        }

        if (!GEMINI_API_KEY) {
            throw new Error('Server Config Error: GEMINI_API_KEY is missing')
        }

        const prompt = `
            You are a helpful language learning assistant. 
            Based on the user's recent learning history provided below, suggest 5 NEW words or short sentences that are relevant to their level and interests.
            
            USER HISTORY (Source: ${sourceLang}, Target: ${targetLang}):
            ${JSON.stringify(history)}

            INSTRUCTIONS:
            1. Suggest items that complement the existing history (e.g., if they learned "apple", suggest "juice" or "fruit").
            2. Provide the translation from ${sourceLang} to ${targetLang}.
            3. For each item, provide:
               - 'sourceText': The text in ${sourceLang}.
               - 'translatedText': The text in ${targetLang}.
               - 'pos': Part of speech (noun, verb, adjective, etc.).
               - 'formType': Grammatical form (past, formal, etc.).
               - 'root': Base lemma of the source word.
               - 'explanation': A very brief usage tip in ${sourceLang}.

            Provide the output in strict JSON format:
            {
                "recommendations": [
                    {
                        "sourceText": "string",
                        "translatedText": "string",
                        "pos": "string",
                        "formType": "string",
                        "root": "string",
                        "explanation": "string"
                    }
                ]
            }
        `

        const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                contents: [{ parts: [{ text: prompt }] }],
            })
        });

        const data = await response.json();
        const rawText = data.candidates[0].content.parts[0].text;
        const jsonMatch = rawText.match(/\{[\s\S]*\}/);
        if (!jsonMatch) throw new Error('AI returned non-JSON response');

        const result = JSON.parse(jsonMatch[0]);

        return new Response(JSON.stringify(result), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })

    } catch (error: any) {
        return new Response(JSON.stringify({ error: error.message }), {
            status: 400,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
    }
})
