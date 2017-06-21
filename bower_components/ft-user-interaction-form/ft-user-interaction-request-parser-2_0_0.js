/*
Copyright 2017 FileThis, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


// InteractionRequestParser_2_0_0

function InteractionRequestParser_2_0_0()
{
    this.generator = null;
}

// Main entry point
InteractionRequestParser_2_0_0.prototype.parse = function(request, generator)
{
    this.generator = generator;

    this.generator.begin();

    this.parseId(request);
    this.parseTitle(request);

    var partCount = request["2.0.0"].parts.length;
    for (var partIndex = 0; partIndex < partCount; partIndex++)
    {
        var part = request["2.0.0"].parts[partIndex];

        switch (part.kind)
        {
            case "static-text":
                this.parseStaticText(request, part);
                break;
            case "text-input":
                this.parseTextInput(request, part);
                break;
            case "choices":
                this.parseChoices(request, part);
                break;
            case "link":
                this.parseLink(request, part);
                break;
            case "button":
                this.parseButton(request, part);
                break;
        }
    }

    this.generator.end();
};

InteractionRequestParser_2_0_0.prototype.parseId = function(request)
{
    var id = request["2.0.0"].id;
    this.generator.generateId(id);
};

InteractionRequestParser_2_0_0.prototype.parseTitle = function(request)
{
    var title = request["2.0.0"].title;
    this.generator.generateTitle(title);
};

InteractionRequestParser_2_0_0.prototype.parseStaticText = function(request, part)
{
    var id = part.id;
    var text = part.text;

    this.generator.generateStaticText(id, text);
};

InteractionRequestParser_2_0_0.prototype.parseTextInput = function(request, part)
{
    var id = part.id;
    var label = part.label;
    var sensitive = part.sensitive;
    var defaultValue = part.default;

    this.generator.generateTextInput(id, label, sensitive, defaultValue);
};

InteractionRequestParser_2_0_0.prototype.parseChoices = function(request, part)
{
    var id = part.id;
    var label = part.label;

    var suggestedWidgetType = part.suggestedWidgetType;

    var defaultChoiceId = null;
    if (part.defaultChoiceId !== undefined)
        defaultChoiceId = part.defaultChoiceId;

    var choices = [];
    var choicesCount = part.choices.length;
    for (var choicesIndex = 0; choicesIndex < choicesCount; choicesIndex++)
    {
        var choice = part.choices[choicesIndex];

        var choiceId = choice.id;
        var choiceLabel = choice.label;

        choices.push({id:choiceId, label:choiceLabel});
    }

    this.generator.generateChoices(id, label, choices, defaultChoiceId, suggestedWidgetType);
};

InteractionRequestParser_2_0_0.prototype.parseLink = function(request, part)
{
    var id = part.id;
    var text = part.text;
    var url = part.url;

    this.generator.generateLink(id, text, url);
};

InteractionRequestParser_2_0_0.prototype.parseButton = function(request, part)
{
    var id = part.id;
    var label = part.label;
    var action = part.action;
    var submit = part.submit;

    this.generator.generateButton(id, label, action, submit);
};
