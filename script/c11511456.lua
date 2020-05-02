--SW Tarpping Lure
function c11511456.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c11511456.condition)
	e1:SetOperation(c11511456.activate)
	c:RegisterEffect(e1)
end
function c11511456.filter(c)
	return c:IsSetCard(0xffb) and c:IsFaceup()
end
function c11511456.condition(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	return bc and bc:IsControler(tp) and bc:IsSetCard(0xffb) and bc:IsFaceup() and Duel.GetMatchingGroupCount(c11511456.filter,tp,LOCATION_MZONE,0,bc)>0
end
function c11511456.activate(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	local g=Duel.GetMatchingGroup(c11511456.filter,tp,LOCATION_MZONE,0,bc)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11511456,0))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local at=Duel.GetAttacker()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) and not tc:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,tc)

			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
			at:RegisterEffect(e1)
		end
	end
end
