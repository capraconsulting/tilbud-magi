import {app, HttpRequest, HttpResponseInit, InvocationContext} from "@azure/functions";
import {PromptAI} from '../app/OpenAIClient'
import {Readable} from "node:stream";
import {Root} from "../types/Notion";


async function streamToString(stream: Readable): Promise<string> {
    return new Promise((resolve, reject) => {
        let data = "";
        stream.on("data", chunk => (data += new TextDecoder().decode(chunk)));
        stream.on("end", () => resolve(data));
        stream.on("error", reject);
    });
}

export async function TilbudMagiFunction(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    context.log(`Http function processed request for url "${request.url}"`);

    const readableStream: Readable = Readable.from(request.body);
    const jsonTextBlob: string = await streamToString(readableStream);
    const incomingData: Root = JSON.parse(jsonTextBlob)

    console.log("Received data: \n", incomingData.data.properties["➡️ BEHOV FRA KUNDEN (💬 FRITEKST)"])

    let ai_output = await PromptAI({model: 'gpt-4o-mini', role: 'user', instruction: 'Say hello'})

    return {body: ai_output};
}

app.http('TilbudMagiFunction', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: TilbudMagiFunction
});