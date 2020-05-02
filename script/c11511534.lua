--Vortex Wrath
function c11511534.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--fusion material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c11511534.fscon)
	e0:SetOperation(c11511534.fsop)
	c:RegisterEffect(e0)
	--cannot negate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCondition(c11511534.con)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e1)
	--Banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11511534.con)
	e1:SetTarget(c11511534.tg)
	e1:SetOperation(c11511534.op)
	c:RegisterEffect(e1)	
end
function c11511534.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(Card.IsFusionSetCard,nil,0xffa)
	mg=mg:Filter(Card.IsType,nil,TYPE_MONSTER)

	local fs=false
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:GetClassCount(Card.GetRace)>=4 and (fs or chkf==PLAYER_NONE)
end
function c11511534.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local sg=eg:Filter(Card.IsFusionSetCard,nil,0xffa)
	sg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	sg:Remove(Card.IsRace,nil,g1:GetFirst():GetRace())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsRace,nil,g2:GetFirst():GetRace())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g3=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsRace,nil,g3:GetFirst():GetRace())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g4=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	Duel.SetFusionMaterial(g1)
end
function c11511534.con(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c11511534.filter(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function c11511534.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local mc=mg:GetFirst()
	local races=0
	while mc do
		races=bit.bor(races,mc:GetRace())
		mc=mg:GetNext()
	end
	e:SetLabel(races)
	local g=Duel.GetMatchingGroup(c11511534.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,nil,races)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c11511534.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11511534.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,nil,e:GetLabel())
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(g:GetCount()*400)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)

	end
end
