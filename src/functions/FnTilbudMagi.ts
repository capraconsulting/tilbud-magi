import {app, HttpRequest, HttpResponseInit, InvocationContext} from "@azure/functions";
import {PromptAI} from '../app/OpenAIClient'

export async function TilbudMagiFunction(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    context.log(`Http function processed request for url "${request.url}"`);

    let ai_output = await PromptAI({model: 'gpt-4o-mini', role: 'user', instruction: 'Say hello'})

    return {body: ai_output};
}

app.http('TilbudMagiFunction', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: TilbudMagiFunction
});