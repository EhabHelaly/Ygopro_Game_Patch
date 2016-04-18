--Warrior's Fury
function c11511049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11511049,3))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
 	e1:SetCondition(c11511049.con)
	e1:SetOperation(c11511049.op)
	c:RegisterEffect(e1)

end
function c11511049.con(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsFaceup() and at:IsSetCard(0xff) and not at:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c11511049.op(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
        --pierce
        local e1=Effect.CreateEffect(at)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PIERCE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        at:RegisterEffect(e1)
        --extra attack
        local e2=Effect.CreateEffect(at)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_EXTRA_ATTACK)
        e2:SetValue(1)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        at:RegisterEffect(e2)
end
