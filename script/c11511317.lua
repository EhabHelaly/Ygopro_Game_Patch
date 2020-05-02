-- Kairem Ancient Tree
function c11511317.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetTarget(c11511317.tg1)
	e1:SetOperation(c11511317.op1)
	c:RegisterEffect(e1)

end
function c11511317.filter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xffc) and ( c:GetSequence()==6 or c:GetSequence()==7 )
end
function c11511317.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511317.filter1,tp,LOCATION_SZONE,0,2,nil) end
end
function c11511317.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c11511317.filter1,tp,LOCATION_SZONE,0,1,1,nil)
	if g1:GetCount()>0 then
		local tc1=g1:GetFirst()
		local g2=Duel.SelectTarget(tp,c11511317.filter1,tp,LOCATION_SZONE,0,1,1,tc1)
		if g2:GetCount()>0 then
			local tc2=g2:GetFirst()
			-- increase first
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc1:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			tc1:RegisterEffect(e2)
			-- decrease second
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_LSCALE)
			e3:SetValue(-1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc2:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UPDATE_RSCALE)
			tc2:RegisterEffect(e4)
		end
	end
end
