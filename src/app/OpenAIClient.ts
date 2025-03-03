import OpenAI from 'openai';

const client: OpenAI = new OpenAI();

interface PromptAIParams {
    model: string;
    role: any;
    instruction: string;
}

export async function PromptAI({model, role, instruction}: PromptAIParams): Promise<any> {
    const stream = await client.chat.completions.create({
        model: model,
        messages: [{role: role, content: instruction}],
        stream: true,
    });

    let output: string = "";

    for await (const chunk of stream) {
        output += chunk.choices[0]?.delta?.content || '';
    }

    return output;
}
