--Elegantea Curse
function c11511052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c11511052.condition)
	e1:SetTarget(c11511052.target)
	e1:SetOperation(c11511052.activate)
	c:RegisterEffect(e1)
end
function c11511052.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	if at== nil then return false else
	return tp~=Duel.GetTurnPlayer() and at:IsFaceup() and at:IsSetCard(0xfff) end
end
function c11511052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c11511052.tgcon(e)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)<4
end
function c11511052.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local c=e:GetHandler()
	local at=Duel.GetAttackTarget()
        --cannot be target
        local e1=Effect.CreateEffect(at)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCondition(c11511052.tgcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(aux.imval1)
        at:RegisterEffect(e1)
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
