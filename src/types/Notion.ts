export interface Root {
    source?: Source
    data: Data
}

export interface Source {
    type: string
    automation_id: string
    action_id: string
    event_id: string
    user_id: string
    attempt: number
}

export interface Data {
    object?: string
    id: string
    created_time?: string
    last_edited_time?: string
    created_by?: CreatedBy
    last_edited_by?: LastEditedBy
    cover?: any
    icon?: any
    parent?: Parent
    archived?: boolean
    in_trash?: boolean
    properties?: Properties
    url?: string
    public_url?: any
    request_id?: string
}

export interface CreatedBy {
    object: string
    id: string
}

export interface LastEditedBy {
    object: string
    id: string
}

export interface Parent {
    type: string
    database_id: string
}

export interface Properties {
    "➡️ BEHOV FRA KUNDEN (💬 FRITEKST)": BehovFraKundenFritekst
}

export interface BehovFraKundenFritekst {
    id: string
    type: string
    rich_text: RichText[]
}

export interface RichText {
    type: string
    text: Text
    annotations: Annotations
    plain_text: string
    href?: string
}

export interface Text {
    content: string
    link?: Link
}

export interface Link {
    url: string
}

export interface Annotations {
    bold: boolean
    italic: boolean
    strikethrough: boolean
    underline: boolean
    code: boolean
    color: string
}
