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


// InteractionRequestParser_1_0_0

function InteractionRequestParser_1_0_0()
{
    this.generator = null;
}

// Main entry point
InteractionRequestParser_1_0_0.prototype.parse = function(request, generator)
{
    this.generator = generator;

    this.generator.begin();

    this.parseId(request);
    this.parseTitle(request);

    var partCount = request.parts.length;
    for (var partIndex = 0; partIndex < partCount; partIndex++)
    {
        var part = request.parts[partIndex];

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
        }
    }

    this.generator.end();
};

InteractionRequestParser_1_0_0.prototype.parseId = function(request)
{
    var id = request.id;
    this.generator.generateId(id);
};

InteractionRequestParser_1_0_0.prototype.parseTitle = function(request)
{
    var title = request.title;
    this.generator.generateTitle(title);
};

InteractionRequestParser_1_0_0.prototype.parseStaticText = function(request, part)
{
    var id = part.id;
    var text = part.text;

    this.generator.generateStaticText(id, text);
};

InteractionRequestParser_1_0_0.prototype.parseTextInput = function(request, part)
{
    var id = part.id;
    var label = part.label;
    var sensitive = part.sensitive;

    this.generator.generateTextInput(id, label, sensitive);
};

InteractionRequestParser_1_0_0.prototype.parseChoices = function(request, part)
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
