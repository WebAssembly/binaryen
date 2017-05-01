function(global, env, buffer) {
    "use asm";
    var Math_fround=global.Math.fround;
    var importf=env._importf;

    function exportf(a){
        a=Math_fround(a);
        return Math_fround(a+Math_fround(1.0))
    }
    function main(){
        Math_fround(importf(Math_fround(3.4000000953674316)));
        return 0
    }

    return{
        main:main,
        exportf:exportf}
}

;

