import { ScriptData } from "./interfaces";

export function generatePowershellCode(list: ScriptData[]): string {
    checkRequierements(list)

    var scriptBody = "#Requires -RunAsAdministrator\n"
    scriptBody += generateFunctionsImport(list)
    scriptBody += generateFunctionsCalls(list)

    return scriptBody
}

function generateFunctionsImport(list: ScriptData[]): string {
    var functionImport = "" 
    
    list.forEach(script => {
        functionImport += script.data + "\n"
    })

    return functionImport
}

function generateFunctionsCalls(scripts: ScriptData[]) {
    var callStack = "" 
    
    scripts.forEach(script => {
        var body = `Write-Host 'Running ${script.name}....'\n`

        if (script.requires !== null) {
            body += `if ($resultHash['${script.requires}']) {` + '\n'
            body += `    try {` + '\n'
            body += `        ${script.name}` + '\n'
            body += `        $resultHash['${script.name}'] = $true` + '\n'
            body += `        Write-Host -ForegroundColor Black  -BackgroundColor Green '${script.name} finished successfully'` + '\n'
            body += `    } catch {` + '\n'
            body += `        $resultHash['${script.name}'] = $false` + '\n'
            body += `        Write-Host -ForegroundColor Black  -BackgroundColor Red '${script.name} failed'` + '\n'
            body += `    }` + '\n'
            body += `} else {` + '\n'
            body += `    Write-Host -ForegroundColor Black  -BackgroundColor Yellow '${script.name} was cancelled due to requierement script fail (${script. requires})'` + '\n'
            body += `    $resultHash['${script.name}'] = $false` + '\n'
            body += `}` + '\n'
        } else {
            body += `try {` + '\n'
            body += `  ${script.name}` + '\n' 
            body += `    $resultHash['${script.name}'] = $true` + '\n'
            body += `     Write-Host -ForegroundColor Black  -BackgroundColor Green '${script.name} finished successfully'` + '\n'
            body += `} catch {` + '\n'
            body += `    $resultHash['${script.name}'] = $false` + '\n'
            body += `    Write-Host -ForegroundColor Black  -BackgroundColor Red '${script.name} failed'` + '\n'
            body += `}` + '\n'
        }

        callStack += body + "\n"
    });

    return callStack
}

export function checkRequierements(list: ScriptData[]) {
    var previous: string[] = [];
    
    list.forEach((script, index) => {
        previous.push(script.name)
        if (script.requires === null) return;
        if (previous.includes(script.requires)) return;
        
        var requirementIndex =  list.findIndex((value) => {
            return value.name === script.requires
        })     

        if (requirementIndex != -1) {
            throw new Error(`${script.name} requires to run ${script.requires} before it starts, but ${script.requires} is in the queue later than ${script.name}.\n` + 
            `Current wrong order: ${script.name} (#${index}) ====> ${script.requires} (#${requirementIndex})\n`) +
            `How should it be: ${script.requires} (#x) ====> ${script.name} (#index > x)`
        } else {
            throw new Error(`${script.name} requires to run ${script.requires} before it starts, but ${script.requires} doesn't exists in queue`)
        }
    });
}
